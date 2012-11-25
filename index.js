var tty = require('tty')
  , nopt = require('nopt')
  , path = require('path')
  , fs = require('fs')
  , shorthand
  , options

var tokenizer = require('glsl-tokenizer')
  , parser = require('glsl-parser')
  , deparser = require('glsl-deparser')
  , minify = require('glsl-min-stream')

options = {
    'safe': [String, Array]
  , 'whitespace': Boolean
  , 'mutate-storage-vars': Boolean
  , 'output': path
  , 'help': Boolean
}

shorthand = {
  's': ['--safe']
, 'h': ['--help']
, 'm': ['--mutate-storage-vars']
, 'w': ['--whitespace']
, 'o': ['--output']
, 'a': ['--safe', "''"]
}

module.exports = run

function help() {
/*
glslmin [-w|--whitespace] [-h|--help] [-o|--output file] [-m|--mutate-storage-vars] [-s|--safe str1 str2...] file1 file2...

  pipeable glsl 1.0 minifier.

  if stdin is a pipe, input will be read from it, otherwise
  glslmin will try to read from the provided files.

  if no output option is defined, output will be written to stdout.

  if multiple files are passed, #ifdef/#endif guards will be created for each file.

  arguments:

    --safe x y z, -s x y z      mark the provided strings as "safe" -- not to be rewritten by the
                                minifier. by default, the only safe word is "main".

    -a                          turn off all "safe" words -- even "main" will be rewritten.

    --whitespace, -w            turn on whitespace output.

    --help, -h                  this help message.

    --mutate-storage-vars, -m   allow mutation of `attribute`, `varying`, and `uniform` variable
                                names. by default, this is false.

    --output path, -o path      output result of minification to file represented by `path`.
                                by default, output will be written to stdout.

*/

  var str = help+''

  process.stdout.write(str.slice(str.indexOf('/*')+3, str.indexOf('*/')))
}

function run() {
  var parsed = nopt(options, shorthand)
    , stdintty = tty.isatty(process.stdin)

  if(parsed.help || (!parsed.argv.remain.length && stdintty)) {
    return help(), process.exit(1)
  }

  var safe_words = parsed.safe || ['main']
    , mutate_storages = parsed['mutate-storage-vars']
    , display_optional_whitespace = parsed.whitespace
    , output = parsed.output ? fs.createWriteStream(parsed.output) : process.stdout
    , inputs = stdintty ? [process.stdin] : parsed.argv.remain.map(to_stream)
    , output_guards = inputs.length > 1
    , idx = 0
    , current = inputs[idx]
    , last = null

  inputs.forEach(function(inp) { inp.pause() })

  return iter()

  function iter() {
    if(idx === inputs.length) {
      if(output_guards) output_close_guard(last.filename)
      return
    }

    if(output_guards) {
      if(last) output_close_guard(last.filename)
      output_open_guard(current.filename)
    }

    current
      .pipe(tokenizer())
      .pipe(parser())
      .pipe(minify())
      .pipe(deparser(!!display_optional_whitespace))
        .on('end', function() {
            last = current
            current = inputs[++idx]
            process.nextTick(iter) 
        })
      .pipe(output, {end: false})

    current.resume()
  }

  function output_open_guard(filename) {
    output.write('\n#ifdef '+filename.toUpperCase().replace(/[^\w\d]/g, '_')+'\n')
  }

  function output_close_guard(filename) {
    output.write('\n#endif /* '+filename+' */\n')
  }
}


function to_stream(p) {
  var stream = fs.createReadStream(path.resolve(p))
  stream.filename = p
  return stream
}
