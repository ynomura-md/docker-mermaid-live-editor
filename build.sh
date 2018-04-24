#!/bin/sh
cd temp && \
  sed -i -e "/^const defaultCode/,/^\`/d" src/utils.js && \
  sed -i -e "/^export const defaultState/i const defaultCode = \"\"" src/utils.js && \
  /usr/local/bin/yarn install && /usr/local/bin/yarn upgrade && /usr/local/bin/yarn release
