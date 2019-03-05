(function() {
  var PLUGIN_NAME, _, assert, gutil, path, reader, through;

  assert = require('assert');

  path = require('path');

  through = require('through2');

  gutil = require('gulp-util');

  _ = require('underscore');

  reader = require('riff-reader');

  PLUGIN_NAME = 'gulp-riff-extractor';

  // chunk id
  module.exports = function(opts) {
    opts = _.defaults(opts, {
      form_type: 'NIKS',
      chunk_ids: void 0,
      header: false,
      padding: false,
      filename_template: "<%= basename %><%= count ? '_' + count : '' %>.<%= id.trim().toLowerCase() %>"
    });
    return through.obj(function(file, enc, cb) {
      var basename, count, dirname, error, extname, rewrited, src, template;
      rewrited = false;
      error = (err) => {
        return this.emit('error', new gutil.PluginError(PLUGIN_NAME, err));
      };
      if (!file) {
        return error('Files can not be empty');
      }
      if (file.isStream()) {
        return error('Streaming not supported');
      }
      count = {};
      dirname = path.dirname(file.path);
      extname = path.extname(file.path);
      basename = path.basename(file.path, extname);
      
      // compile file name template
      template = _.template(opts.filename_template);
      
      // iterate chunks
      src = file.isNull() ? file.path : file.contents;
      reader(src, opts.form_type).readSync((id, data) => {
        var b, contents, filename, test;
        // count each chunk id
        if (_.isNumber(count[id])) {
          count[id] += 1;
        } else {
          count[id] = 0;
        }
        
        // bind template paramaters
        filename = template({
          id: id,
          basename: basename,
          count: count[id]
        });
        contents = data;
        
        // include header chunk id and size
        if (opts.header) {
          b = Buffer.alloc(8);
          b.write(id, 0, 4, 'ascii');
          b.writeUInt32LE(data.length, 4);
          contents = Buffer.concat([b, contents]);
        }
        
        // append padding byte
        if (opts.padding && data.length & 0x01) {
          b = Buffer.from([0]);
          contents = Buffer.concat([contents, b]);
        }
        test = path.join(dirname, filename);
        return this.push(new gutil.File({
          base: file.base,
          cwd: file.cwd,
          path: path.join(dirname, filename),
          contents: contents
        }));
      }, opts.chunk_ids);
      return cb();
    });
  };

}).call(this);
