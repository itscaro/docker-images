#!/usr/bin/env python

# Copyright (c) Minh Quan TRAN, 2018

import os
from jinja2 import Environment, FileSystemLoader, select_autoescape
import yaml
from pprint import pprint
dir_path = os.path.dirname(os.path.realpath(__file__))
os.chdir(dir_path)

images = ["php7.1-node8", "php7.1-node8-stretch", "php7.2-node10", "php7.3-node10"]

env = Environment(
    loader=FileSystemLoader(dir_path),
    keep_trailing_newline=True,
)

stream = open("Dockerfile.yaml", "r")
docs = yaml.load_all(stream)
data = None
for doc in docs:
    if doc is None:
        continue

    print("Template: ", doc['template'])

    for image, v in doc['images'].items():
        print("\t", os.path.dirname(doc['template']) + os.sep + v['file'])

        template = env.get_template(doc['template'])
        template.stream(
            {
                'base_image': v.get('base_image', None),
                'image': v.get('image', None),
                'data': v.get('data', None),
                'entrypoint': doc.get('entrypoint', []),
            }
        ).dump(os.path.dirname(doc['template']) + os.sep + v['file'])

    print()
