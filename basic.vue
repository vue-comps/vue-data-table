<template lang="pug">
.container
  a(href="https://github.com/vue-comps/vue-data-table/blob/master/dev/basic.vue") source
  data-table(v-ref:dt v-bind:height="200" v-bind:data="dataSet")
    data-table-column(name="name" v-bind:width=80 pinned) {{data.first + " " + data.last}}
      span(slot="header") Name (first + last)
    data-table-column(name="age") {{data.age}}
      span(slot="header") age
        vue-icon(name="octicon-info" size=12 style="margin-left:2px")
          tooltip(position="body") Custom header with icon and tooltip
    data-table-column(name="registered") {{data.registered}}
      tooltip(position="body") {{data.about}}
      span(slot="header") registered
        vue-icon(name="octicon-info" size=12 style="margin-left:2px")
          tooltip(position="body") Custom cell with tooltip
    data-table-column(name="longitude") {{data.longitude}}
    data-table-column(name="latitude") {{data.latitude}}
    data-table-column(name="address") {{data.address}}
    data-table-column(name="phone") {{data.phone}}
    data-table-column(name="email") {{data.email}}
    data-table-column(name="company") {{data.company}}
</template>

<script lang="coffee">
module.exports =
  components:
    "data-table": require "../src/data-table.vue"
    "data-table-column": require "../src/data-table-column.vue"
    "vue-icon": require "vue-icons/icon"
    "tooltip": require("vue-comps-tooltip")
  data: ->
    dataSet: require "./data.json"
</script>

<style lang="stylus">
.dt-main
  border 1px solid black
.dt-header,
.dt-cell
  border-right 1px solid black
  padding 2px
.dt-header
  border-bottom 1px solid black
.dt-cell
  border-top 1px solid black
  overflow: hidden
.dt-headers-pinned,
.dt-content-pinned
  background #eee
.tooltip
  background #fff
  border 1px solid black
  padding 4px
</style>
