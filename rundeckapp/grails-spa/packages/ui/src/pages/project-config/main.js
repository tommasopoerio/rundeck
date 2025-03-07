// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vue2Filters from 'vue2-filters'
import VueCookies from 'vue-cookies'
import PageConfirm from '@rundeck/ui-trellis/lib/components/utils/PageConfirm'
import * as uiv from 'uiv'
import VueI18n from 'vue-i18n'
import international from './i18n'
import uivLang from '@rundeck/ui-trellis/lib/utilities/uivi18n'
import {getRundeckContext} from '@rundeck/ui-trellis'
import PluginSetConfig from './PluginSetConfig'
import ProjectPluginGroups from "./ProjectPluginGroups";

Vue.config.productionTip = false

Vue.use(Vue2Filters)
Vue.use(VueCookies)
Vue.use(uiv)
Vue.use(VueI18n)

let messages = international.messages
let locale = window._rundeck.locale || 'en_US'
let lang = window._rundeck.language || 'en'

// include any i18n injected in the page by the app
messages = {
    [locale]: Object.assign({},
        uivLang[locale] || uivLang[lang] || {},
        window.Messages,
        messages[locale] || messages[lang] || messages['en_US'] || {}
    )
}
const context = getRundeckContext()
// Create VueI18n instance with options
/* eslint-disable no-new */
const els = document.body.getElementsByClassName('project-config-plugins-vue')

for (var i = 0; i < els.length; i++) {
    const e = els[i]

    const i18n = new VueI18n({
        silentTranslationWarn: false,
        locale: locale, // set locale
        messages // set locale messages,

    })
    new Vue({
        el: e,
        data() {
            return {
                EventBus: context.eventBus
            }
        },
        components: {
            PageConfirm,
            PluginSetConfig,
            ProjectPluginGroups
        },
        i18n
    })
}
