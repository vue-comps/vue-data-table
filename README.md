# vue-data-table

A high-customizable data-table based on [vue-clusterize](https://github.com/vue-comps/vue-clusterize)

Has invisible pagination with dynamic data, pinned columns and template based header / cells.

### [Demo](https://vue-comps.github.io/vue-data-table/)

# Disclaimer

Only for [**webpack**](https://webpack.github.io/) workflows.

**No jQuery dependency**

# Install

```sh
npm install --save-dev vue-data-table
```
"data-table": require "../src/data-table.vue"
"data-table-column": require "../src/data-table-column.vue"
## Usage
```coffee
# link the components up
components:
  "data-table": require "vue-data-table/data-table"
  "data-table-column": require "vue-data-table/data-table-column"
# or ES6
import {dataTable,dataTableColumn} from "vue-data-table"
components: {
  "data-table": dataTable
  "data-table-column": dataTableColumn
}
```
```html
<data-table :height="200" :data="dataSet">
  <data-table-column name="name" :width=80 pinned>
    {{data.first + " " + data.last}}
    <span slot="header"> Name (first + last)</span>
  </data-table-column>
</data-table>
```
For examples see [`dev/`](https://github.com/vue-comps/vue-data-table/tree/master/dev).

#### Props
##### data-table
| Name | type | default | description |
| ---:| --- | ---| --- |
| binding-name | String | "data" | name to access the data in your template |
| height | Number | null | Height of the clusterize element |
| auto-height | Boolean | false | If autoheight should be used (see below) |
| manual-start | Boolean | false | rendering doesn't start on `ready` (call `start` on the component instance instead)|
| data | Array | [] | static data to render |
| scrollTop | Number | 0 | sets scrollTop |
| scrollLeft | Number | 0 | sets scrollLeft |

##### data-table-column
| Name | type | default | description |
| ---:| --- | ---| --- |
| name | String | - | (required) name of the column. Used as default for the header. Must be unique |
| style | Object | {whiteSpace:"nowrap"} | style for the header of the column. |
| pinned | Boolean | false | column will be on the left, always visible |
| noResize | Boolean | false | disable resize of this column |
| width | Number | -1 | initial width of the column (defaults to width of the header) |
| minWidth | Number | -1 | minimal width of the column (defaults to width of the header) |
| maxWidth | Number | Number.MAX_VALUE | maximal width of the column |
| defaultWidth | Number or String | "auto" | width of the column on double click on resizer. "auto" looks for content width of the column |

## Autoheight

There are two ways data-table can be used, either use a fixed height:
```html
<data-table :data="dataSet" :height="400">
```

Or use autoheight:
```html
<html style="height:100%">
  <body style="height:100%">
    <div style="position:relative">
      <data-table :data="dataSet" auto-height>
```
In this case data-table will always fill the nearest parent element with either `position:relative;` or `position:absolute;`
Keep in mind, that `padding` of the parent will be ignored. If you need a padding, use a wrapper `<div>`.

## Dynamic data

The data-table instance emits to events to get dynamic data:
```html
<data-table @get-data="getData" @get-data-count="getDataCount">
```
```js
methods:
  # For the first datapiece, first and last will be 0
  getData: function(first,last,cb) {
      # somehow get data
      cb(data)
    }
  getDataCount: function(cb) {
    cb(dataCount)
  }
```
# Development
Clone repository.
```sh
npm install
npm run test
```
Browse to `http://localhost:8080/`.

## To-Do
- allow more than one (fixed-width) object per row + autosize to adjust #objects to actual width.
- use html5 history mode or document.store to save scroll position

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.
