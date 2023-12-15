import * as Vue from "https://cdn.jsdelivr.net/npm/vue@3.2.26/dist/vue.esm-browser.prod.js";

export function init(ctx, info) {
  ctx.importCSS("main.css");
  ctx.importCSS(
    "https://fonts.googleapis.com/css2?family=Inter:wght@400;500&display=swap"
  );

  const BaseInput = {
    name: "BaseInput",

    props: {
      label: {
        type: String,
        default: ""
      },
      inputClass: {
        type: String,
        default: "input"
      },
      modelValue: {
        type: [String, Number],
        default: ""
      },
      inline: {
        type: Boolean,
        default: false
      },
      grow: {
        type: Boolean,
        default: false
      },
      number: {
        type: Boolean,
        default: false
      }
    },

    computed: {
      emptyClass() {
        if (this.modelValue === "") {
          return "empty";
        }
      }
    },

    template: `
    <div v-bind:class="[inline ? 'inline-field' : 'field', grow ? 'grow' : '']">
      <label v-bind:class="inline ? 'inline-input-label' : 'input-label'">
        {{ label }}
      </label>
      <input
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        v-bind="$attrs"
        v-bind:class="[inputClass, number ? 'input-number' : '', emptyClass]"
      >
    </div>
    `
  };

  const app = Vue.createApp({
    components: {
      BaseInput: BaseInput
    },

    template: `
    <div class="app">
      <!-- Info Messages -->
      <form @change="handleFieldChange">
        <div class="container">
          <div class="row header">
            <span class="cell-title">
              Connect to Meadow DB
            </span>
            <BaseInput
              name="variable"
              label=" Assign to "
              type="text"
              v-model="fields.variable"
              inputClass="input input--xs input-text"
              :inline
            />
          </div>
        </div>
      </form>
    </div>
    `,

    data() {
      return {
        fields: info.fields,
        helpBox: info.help_box
      };
    },

    computed: {},

    methods: {
      handleFieldChange(event) {
        const field = event.target.name;
        if (field) {
          const value = this.fields[field];
          ctx.pushEvent("update_field", { field, value });
        }
      }
    }
  }).mount(ctx.root);

  ctx.handleEvent("update", ({ fields }) => {
    setValues(fields);
  });

  ctx.handleSync(() => {
    // Synchronously invokes change listeners
    document.activeElement &&
      document.activeElement.dispatchEvent(
        new Event("change", { bubbles: true })
      );
  });

  function setValues(fields) {
    for (const field in fields) {
      app.fields[field] = fields[field];
    }
  }
}
