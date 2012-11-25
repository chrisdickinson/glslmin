# glslmin

A CLI for minifying GLSL (WebGL) 1.00 shaders.

Supports bundling multiple shaders into a single file with `#ifdef` guards (so you
only have to make one request for shader assets in WebGL).

Supports "safe" word configuration -- by default, only "main" (and attribute/varying/uniform declaration) is safe.

Pipeable, if you're into that.

# installation

```
$ npm install -g glslmin
```

# usage

```

$ glslmin
# prints help

$ glslmin file.glsl
# prints file, minified

$ glslmin file.glsl -o file.min.glsl
# outputs minified data to file.min.glsl

$ glslmin file.glsl file2.glsl -o file.min.glsl
# outputs minified data for each file, surrounded by #ifdef guards

$ cat file.glsl | glslmin
# outputs minified data

# see help for more options!

```

# license

MIT
