#!/bin/bash

git clone git@github.com:jeksterslab/manMetaVAR.git
rm -rf "$PWD.git"
mv manMetaVAR/.git "$PWD"
rm -rf manMetaVAR
