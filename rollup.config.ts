import * as fs from 'fs';
import * as path from 'path';

import strip from '@rollup/plugin-strip';
import terser from '@rollup/plugin-terser';
import resolve from '@rollup/plugin-node-resolve';

import stylus from 'rollup-plugin-stylus-compiler';
import css from 'rollup-plugin-css-only';
import { minify } from 'csso';

const root = new URL(path.dirname(import.meta.url)).pathname
    , src = path.join(root, 'src')
    , dst = path.join(root, 'dst')
    ;

const debug = {
  input: path.join(src, 'asset', 'index.js')
, output: {
    file: path.join(dst, 'js', 'index.js')
  , format: 'iife'
  , sourcemap: true
  }
, plugins: [
    resolve({
      browser: true
    , preferBuiltins: false
    , mainFields: ['dev:module', 'module', 'main', 'jsnext:main']
    , extensions: ['.js', '.json', '.ts', '.css', '.svg']
    })
  , stylus()
  , css({
      output: function(data: string, _nodes: any) {
        const file = path.join(dst, 'css', 'index.css');
        fs.mkdir(path.dirname(file), {recursive: true}, (err) => {
          if (err) throw err;
          fs.writeFileSync(file, minify(data).css);
        });
      }
    })
  , strip()
  , terser()
  ]
}

const release = {
};

type Args = {
  [key: string]: boolean | number | string;
};

export default (args: Args) => {
  if (args.configBuildDebug === true) {
    return debug;
  }
  console.error('TODO');
  // return release;
}
