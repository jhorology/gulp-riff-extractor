## gulp-riff-extractor

Gulp plugin for extracting RIFF (Resource Interchange File Format) file's chunks.

## Installation
```
  npm install gulp-riff-extractor --save-dev
```

## Usage

```coffeescript

extract = require 'gulp-riff-extractor'

gulp.task '_test-default', ['default'], ->
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      .pipe gulp.dest './test_out'
```

output:
```
  ./test_out/sample.nisi
  ./test_out/sample.plid
  ...
```




## API

### extract(options)
 create new reader instance.

#### options.form_type
Type: `String`, Required

The form type of RIFF file. 4 characters.

#### options.chunk_ids
Type: array of  `String`, Optional, Default: all chunks

The array of chunk id to extract for.

#### options.header
Type: `Boolean`, Optional, Default: false

include chunk header (chunk id and size).

#### options.padding
Type: `Boolean`, Optional, Default: false

include padding byte for 16bit boundary.

#### options.filename_template
Type: `String`, Optional

Default:
```javascript
"<%= basename %><%= count ? '_' + count : '' %>.<%= id.trim().toLowerCase() %>"
```

- basename: src filename without extension.
- count: count for each chunk id. 
- id: The chunk id. 


## TODO
- support streaming.
