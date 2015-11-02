(function() {
  var PLUGIN_NAME, _, assert, gutil, path, reader, through;

  assert = require('assert');

  path = require('path');

  through = require('through2');

  gutil = require('gulp-util');

  _ = require('underscore');

  reader = require('riff-reader');

  PLUGIN_NAME = 'gulp-riff-extractor';

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
      error = (function(_this) {
        return function(err) {
          return _this.emit('error', new gutil.PluginError(PLUGIN_NAME, err));
        };
      })(this);
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
      template = _.template(opts.filename_template);
      src = file.isNull() ? file.path : file.contents;
      reader(src, opts.form_type).readSync((function(_this) {
        return function(id, data) {
          var b, contents, filename;
          if (_.isNumber(count[id])) {
            count[id] += 1;
          } else {
            count[id] += 0;
          }
          filename = template({
            id: id,
            basename: basename,
            count: count[id]
          });
          contents = data;
          if (opts.header) {
            b = new Buffer(8);
            b.write(id, 0, 4, 'ascii');
            b.writeUInt32LE(data.length, 4);
            contents = Buffer.concat([b, contents]);
          }
          if (opts.padding && data.length & 0x01) {
            b = new Buffer(1);
            contents = Buffer.concat([b, contents]);
          }
          return _this.push(new gutil.File({
            path: path.join(dirname, filename),
            contents: contents
          }));
        };
      })(this), opts.chunk_ids);
      return cb();
    });
  };

}).call(this);
