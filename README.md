# CRA Templator
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![GitHub license](https://img.shields.io/github/license/drewlong/crat)
![GitHub release](https://img.shields.io/github/v/release/drewlong/crat?include_prereleases)
![Travis-CI Build](https://travis-ci.com/drewlong/crat.svg?branch=master)
____

CRAT is a dead-simple way to jumpstart projects, using CRA and a little bit of Ruby
under the hood. You simply init a template, customize the configuration, and add some static files. It's not revolutionary, it just makes the life of a developer a little bit easier.

#### Installation

Simply clone the repo, cd into the project folder and run:

`./install.sh`

You'll need Ruby v2.4 or above and npm version 10 or above.

#### Usage

```
Basic usage:          crat -n [project name] -t [template name]
List All Templates:   crat -l
Create New Template:  crat -c
```

CRAT stores templates (and everything else) in `~/.crat`. When you run `crat -l`, it reads the
available template folders in `~/.crat/templates/`. When you create a new template with `crat -c`, it creates the necessary template config file, `template.json`, with some boilerplate and sets up the `static` folder for static assets.

Example output of `crat -l`:

![list](https://user-images.githubusercontent.com/20236454/77111582-f8cc4380-69fd-11ea-9133-8f10bf980cff.png)

#### Creating a Template

There's not much to it. Run the create command and then migrate to your template directory. Inside, you'll find a template JSON file with some familiar fields:

```
{
  "name": "New App",
  "description": "",
  "dependencies": {
    "axios": "latest"
  },
  "folders": [
    {
      "path": "src/css"
    }
  ]
}
```

Feel free to get rid of the fields in `dependencies` and `folders` and replace them with your own values. Here's a brief explanation of how to set these fields appropriately:

1. **Name**: This is set automatically based on the terminal input from the creation step.
2. **Description**: Mostly for your own tracking, this is used when listing the templates.
3. **Dependencies**: This is an object holding the dependency names for any additional packages you'd like to include in your project. That is to say, they are in addition to what CRA automatically includes. Accepts the same values as a package.json file.
4. **Folders**: Create an entry for the last folder in every path you'd like to create. For example, if you want `layouts/` and `layouts/dashboard`, you only need an entry for `layouts/dashboard` because the full path will be created. _Note: the paths should be relative to the project root, not the src directory_

#### License

This project is licensed under the MIT License.

#### Contribution

Feel free to fork and contribute!
