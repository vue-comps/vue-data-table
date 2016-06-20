<template lang="pug">
.dt-cell(
  class="dt-cell-{{child.name}}"
  v-bind:style="{width: {{child.name}}width+'px'}"
  style='display:inline-block;line-height:normal')
  span
    slot
</template>
