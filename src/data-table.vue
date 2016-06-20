// out: ..
<template lang="pug">
.dt-main(
  v-bind:style="style"
  style="overflow:hidden"
  )
  .dt-headers(
    v-el:header
    style="white-space:nowrap;line-height:0"
    )
    .dt-headers-pinned(
      v-if="!started || columnsPinned.length > 0"
      style="display:inline-block;vertical-align:top"
      v-el:pinned-header
      )
    .dt-headers-normal(
      v-el:normal-header
      style="display:inline-block;overflow:hidden;white-space:nowrap"
      v-bind:style="{width:normalWidth+'px'}"
      )
      slot
      div(
        style="display:inline-block"
        v-bind:style="{'width':hovered?scrollBarSize.width+'px':0}"
        )

  .dt-contents(
    :style="{height:clusterizeHeight+'px'}"
    style="overflow:hidden;white-space:nowrap"
    @mouseenter="onMouseEnter"
    @mouseleave="onMouseLeave"
  )
    .dt-content.dt-content-pinned(
      v-if="!started || columnsPinned.length > 0"
      style="display:inline-block;vertical-align:top;overflow:hidden;position:relative;box-sizing:border-box"
      v-bind:style="{height:pinnedHeight+'px',width:pinnedWidth}"
      )
      clusterize(
        v-ref:clusterize-pinned
        manual-start
        v-bind:parent-vm="parentVm"
        v-bind:binding-name="bindingName"
        v-bind:height="pinnedHeight"
        @get-data="getData"
        @get-data-count="getDataCount"
        @scroll-y="onScrollY"
        v-bind:scroll-top="scrollTop"
        v-bind:style="{'overflow-y':hovered?'scroll':'hidden','position':hovered?'absolute':null,'overflow-x':'hidden'}"
        )
    .dt-content.dt-content-normal(
      v-el:content
      style="display:inline-block;vertical-align:top;"
      v-bind:style="{'max-width':normalWidth+'px'}"
      )
      clusterize(
        v-ref:clusterize
        manual-start
        v-bind:parent-vm="parentVm"
        v-bind:binding-name="bindingName"
        v-bind:height="clusterizeHeight"
        @get-data="getData"
        @get-data-count="getDataCount"
        v-bind:style="{'overflow':hovered?'scroll':'hidden'}"
        @scroll-y="onScrollY"
        @scroll-x="onScrollX"
        v-bind:scroll-top="scrollTop"
        )
</template>

<script lang="coffee">
module.exports =

  mixins: [
    require "vue-mixins/onElementResize"
    require "vue-mixins/fragToString"
  ]

  components:
    "clusterize": require "vue-clusterize/clusterize"


  props:
    "bindingName":
      type: String
      default: "data"
    "height":
      type: Number
    "data":
      type: Array
    "scrollTop":
      type: Number
      default: 0
    "scrollLeft":
      type: Number
      default: 0
    "manualStart":
      type: Boolean
      default: false
    "autoHeight":
      type: Boolean
      default: false

  computed:
    position: ->
      if @autoHeight
        unless @disposeResizeCb?
          @disposeResizeCb = @onElementResize @$el, =>
            @clientHeight = @$el.clientHeight
        return "absolute"
      else
        @disposeResizeCb?()
        return "relative"
    style: ->
      height: @height+'px'
      position: @position
      top: if @autoHeight then 0 else null
      bottom: if @autoHeight then 0 else null
    totalHeight: ->
      if @height
        return @height
      else
        return null unless @ready
        @clientHeight = @$el.clientHeight
        return @clientHeight

    clusterizeHeight: ->
      return null unless @ready
      return @totalHeight - @$els.header.offsetHeight
    pinnedHeight: ->
      return null unless @ready
      return @clusterizeHeight - @hovered*@scrollBarSize.height

  data: ->
    ready: false
    started: false
    pinnedContentHeight: -1
    columnsPinned: []
    columns: []
    parentVm: @$parent
    hovered: false
    pinnedWidth: null
    scrollBarSize:
      width: 0
      height: 0
    normalWidth: null
    clientHeight: null

  methods:
    hasWidth: (width, oldWidth, currentWidth) ->
      diff = width - currentWidth
      return diff < 0 or diff < @$els.header.clientWidth*0.8 -
        @$els.pinnedHeader.offsetWidth
    resetWidth: (pinned,name,width) ->
      clusterize = if pinned then @$refs.clusterizePinned else @$refs.clusterize
      for cluster in clusterize.clusters
        for frag in cluster.frags
          cell = frag.node.querySelector(".dt-cell-#{name}>span")
          if cell? and cell.offsetWidth > width
            width = cell.offsetWidth
      return width
    getData: (first,last,cb) ->
      if @data?
        cb(@data[first..last])
      else
        @$emit("get-data",first,last,cb)
    getDataCount: (cb) ->
      if @data?
        cb(@data.length)
      else
        @$emit("get-data-count",cb)
    onMouseEnter: (e) ->
      @hovered = true
      @$nextTick =>
        @onPinnedWidthChange()
        if @scrollBarSize.width == 0
          @scrollBarSize.width = @$refs.clusterize.$el.offsetWidth - @$refs.clusterize.$el.clientWidth
        if @scrollBarSize.height == 0
          @scrollBarSize.height = @$refs.clusterize.$el.offsetHeight - @$refs.clusterize.$el.clientHeight
    onMouseLeave: ->
      @hovered = false
      @pinnedWidth = null
    onPinnedWidthChange: ->
      @normalWidth = @$els.header.clientWidth - @$els.pinnedHeader.offsetWidth
      @pinnedWidth = @$els.pinnedHeader.getBoundingClientRect().width+'px' if @hovered
    onScrollY: (top) ->
      @scrollTop = top
    onScrollX: (left) ->
      @$els.normalHeader.scrollLeft = left
    start: ->
      @started = true
      @$refs.clusterize.start()
      @$refs.clusterizePinned.start()

  ready: ->
    cellTemplate = require("./data-table-cell").template
    rowTemplate = require("./data-table-row").template
    cellsTemplate =  ""
    watchers = {}
    cellsTemplatePinned = ""
    watchersPinned = {}
    for child in @$children
      if child.isColumn
        if child.pinned
          @columnsPinned.push child
          child.$appendTo @$els.pinnedHeader
          cellsTemplatePinned += cellTemplate
            .replace(/{{child\.name}}/g,child.name)
            .replace("<slot></slot>", @fragToString(child._slotContents.default))
          watchersPinned[child.name+"width"] = {vm: child, prop:"width"}
        else
          @columns.push child
          cellsTemplate += cellTemplate
            .replace("<slot></slot>", @fragToString(child._slotContents.default))
            .replace(/{{child\.name}}/g,child.name)
          watchers[child.name+"width"] = {vm: child, prop:"width"}
    @$refs.clusterize.rowWatchers = watchers
    @$refs.clusterize.template = rowTemplate.replace("<slot></slot>",cellsTemplate)
    if @columnsPinned.length > 0
      @$refs.clusterizePinned.rowWatchers = watchersPinned
      @$refs.clusterizePinned.template = rowTemplate.replace("<slot></slot>",cellsTemplatePinned)
    @$nextTick =>
      @ready = true
      @start() unless @manualStart

</script>
