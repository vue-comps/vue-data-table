// out: ..
<template lang="pug">
.dt-header(
  v-bind:style="computedStyle",
  style="display:inline-block;position:relative")
  div(style="overflow:hidden")
    slot(name="header") {{name}}
  resizer(
    v-if="!noResize"
    v-bind:size="width"
    v-bind:min-size="minWidth"
    v-bind:default-size="defWidth"
    v-bind:max-size="maxWidth"
    @resize="onResize"
    @reset-size="onResetSize"
    )
  div(v-if="false")
    slot
</template>

<script lang="coffee">
module.exports =
  components:
    "resizer": require "vue-resize-handle/unidirectional"
  props:
    "style":
      type: Object
      default: ->
        {whiteSpace:"nowrap"}
    "name":
      type: String
      required: true
    "pinned":
      type:Boolean
      default: false
    "width":
      type: Number
      default: -1
    "defaultWidth":
      default: "auto"
    "minWidth":
      type: Number
      default: -1
    "maxWidth":
      type: Number
      default: Number.MAX_VALUE
    "noResize":
      type:Boolean
      default: false

  computed:
    computedStyle: ->
      style = {
        width: @width+'px'
        lineHeight:"normal"
      }
      for key,val of @style
        style[key] = val
      return style
    defWidth: ->
      return @width if @defaultWidth == "auto"
      return +@defaultWidth

  data: ->
    isColumn: true

  methods:
    onResize: (width, oldWidth) ->
      if not @pinned or (@pinned and @$parent.hasWidth(width,oldWidth, @width))
        @width = width
    onResetSize: ->
      if @defaultWidth == "auto"
        newWidth = @$parent.resetWidth(@pinned,@name,@width)
        if newWidth < @minWidth
          newWidth = @minWidth
        else if newWidth > @maxWidth
          newWidth = @maxWidth
        @width = newWidth
    processNewWidth: ->
      if @pinned
        @$nextTick =>
          @$parent.onPinnedWidthChange()
    onClick: (e) ->
      @$emit "click", e

  ready: ->
    @width = @$el.clientWidth if @width == -1
    @minWidth = @$el.clientWidth if @minWidth == -1

  watch:
    width: "processNewWidth"
</script>
