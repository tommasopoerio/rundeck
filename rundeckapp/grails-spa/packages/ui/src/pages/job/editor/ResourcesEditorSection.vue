<template>
  <div >
    <ui-socket section="resources-editor" location="top" :event-bus="eventBus" />
    <resources-editor v-model="updatedData" :event-bus="eventBus" v-if="updatedData"/>
    <json-embed :output-data="updatedData" field-name="resourcesJsonData"/>
  </div>
</template>

<script>
import ResourcesEditor from '../../../components/job/resources/ResourcesEditor.vue'
import UiSocket from '../../../components/ui/UiSocket.vue'
import JsonEmbed from './JsonEmbed.vue'

import {
  getRundeckContext,
  RundeckContext
} from "@rundeck/ui-trellis"

const rootStore = getRundeckContext().rootStore
export default {
  name: 'ResourcesEditorSection',
  props:['eventBus' ],
  provide:{
    rootStore
  },
  components: {
    ResourcesEditor,
    JsonEmbed,
    UiSocket
  },
  data () {
    return {
      resourcesData: {},
      updatedData:null,
      watching:false
    }
  },
  watch:{
    updatedData(){
        if(this.watching) {
            if(!_.isEqual(this.resourcesData,this.updatedData)){
                window.jobWasEdited()
            }
        }
    }
  },
  async mounted () {
    if(window._rundeck && window._rundeck.data){
        this.resourcesData = window._rundeck.data.resourcesData
        this.updatedData = Object.assign({}, this.resourcesData)
        this.watching = true
    }
  }
}
</script>

<style>
</style>
