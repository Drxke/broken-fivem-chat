Vue.component('message', {
  template: '#message_template',
  data() {
    return {};
  },
  computed: {
    textEscaped() {
      let s = this.template ? this.template : this.templates[this.templateId];

      if (this.template) {
        //We disable templateId since we are using a direct raw template
        this.templateId = -1;
      }

      //This hack is required to preserve backwards compatability
      if (this.templateId == CONFIG.defaultTemplateId
          && this.args.length == 1) {
        s = this.templates[CONFIG.defaultAltTemplateId] //Swap out default template :/
      }

      s = s.replace(/{(\d+)}/g, (match, number) => {
        const argEscaped = this.args[number] != undefined ? this.escape(this.args[number]) : match
        if (number == 0 && this.color) {
          //color is deprecated, use templates or ^1 etc.
          return this.colorizeOld(argEscaped);
        }
        return argEscaped;
      });
      return this.colorize(s);
    },
  },
  methods: {
    colorizeOld(str) {
      return `<span style="color: rgb(${this.color[0]}, ${this.color[1]}, ${this.color[2]})">${str}</span>`
    },
    colorize(str) {
      let s = "<span>" + (str.replace(/\^([0-9])/g, (str, color) => `</span><span class="color-${color}">`)) + "</span>";

      const styleDict = {
        '*': 'font-weight: bold;',
        '_': 'text-decoration: underline;',
        '~': 'text-decoration: line-through;',
        '=': 'text-decoration: underline line-through;',
        'r': 'text-decoration: none;font-weight: normal;',
      };

      const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
      while (s.match(styleRegex)) { //Any better solution would be appreciated :P
        s = s.replace(styleRegex, (str, style, inner) => `<em style="${styleDict[style]}">${inner}</em>`)
      }
      return s.replace(/<span[^>]*><\/span[^>]*>/g, '');
    },
    escape(unsafe) {
      return String(unsafe)
       .replace(/&/g, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/>/g, '&gt;')
       .replace(/"/g, '&quot;')
       .replace(/'/g, '&#039;');
    },
  },
  props: {
    templates: {
      type: Object,
    },
    args: {
      type: Array,
    },
    template: {
      type: String,
      default: null,
    },
    templateId: {
      type: String,
      default: CONFIG.defaultTemplateId,
    },
    multiline: {
      type: Boolean,
      default: false,
    },
    color: { //deprecated
      type: Array,
      default: false,
    },
  },
});

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (factory((global.emojer = {})));
}(this, (function (exports) {
  'use strict';

  /**
   * The list of the emojis following their char codes
   */
  var emojiCodes = {
    ':)': 0x1f604,
    ':(': 0x1f626,
    ':P': 0x1f61b,
    ':D': 0x1f601,
    ';)': 0x1f609,
    ":')": 0x1f622,
    ':poop:': 0x1f4a9,
    ':100:': 0x1f4af,
    ':tm:': 0x2122,
    ':flag_au:': 0x1f1e6,
    '<3': 0x1f49b,
    ':blue_heart:': 0x1f499,
    ':thinking:': 0x1f914
  };

  /**
   * Configs
   */
  var configs = {
    span_class: [],
    html: true
  };

  /**
   * Appends a emoji font to render the emojers properly
   */
  var createStyle = function createStyle() {
    var style = document.createElement('style');
    style.rel = 'stylesheet';
    style.type = 'text/css';

    var css = '.emojer-icon{font-family:"Apple Color Emoji","Segoe UI","Segoe UI Emoji","Segoe UI Symbol",Helvetica,Arial,sans-serif}';

    if (style.styleSheet) {
      style.styleSheet.cssText = css;
    } else {
      style.appendChild(document.createTextNode(css));
    }

    document.body.appendChild(style);
  };

  /**
   * Add a new emoji to the list
   *
   * @param {String} character The character to be replaced by emoji
   * @param {Number} charCode The char code
   */
  var addEmoji = function addEmoji(character, charCode) {
    if (typeof charCode !== 'number') throw new Error('emojer: charCode must be a number.');

    emojiCodes[character] = charCode;
  };

  /**
   * Sets the new configs to be passed to the emojer
   *
   * @param {object} newConfigs The new configs to be replaced
   */
  var setConfigs = function setConfigs(newConfigs) {
    configs = Object.assign({}, configs, newConfigs);
  };

  /**
   * Escapes some characters to be a valid RegExp expression
   *
   * @param {String} str The string to be replaced
   */
  var escapeRegExp = function escapeRegExp(str) {
    return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
  };

  /**
   * Polyfill to the native method String.fromCodePoint
   */
  var fromCodePoint = function fromCodePoint() {
    if ('fromCodePoint' in String) return String.fromCodePoint(arguments[0]);

    var chars = Array.prototype.slice.call(arguments);

    for (var i = chars.length; i-- > 0;) {
      var n = chars[i] - 0x10000;
      if (n >= 0) chars.splice(i, 1, 0xd800 + (n >> 10), 0xdc00 + (n & 0x3ff));
    }

    return String.fromCharCode.apply(null, chars);
  };

  /**
   * Detects if the env is a browser.
   */
  var isBrowser = new Function('try {return this===window;}catch(e){ return false;}');

  /**
   * Main function. Find into the text the characters to be replaced by the emojis according to the emojiCodes.
   *
   * @param {String} text The text to be replaced by the emojis
   */
  var replace = function replace(text) {
    var keys = Object.keys(emojiCodes);
    var i = keys.length;

    while (i--) {
      var key = keys[i];
      var code = emojiCodes[key];

      var value = fromCodePoint(code);

      text = text.replace(new RegExp(escapeRegExp(key), 'g'), value);
    }

    return text;
  };

  /**
   * Parse the string/source and returns the string with the new emojis
   *
   * @param {String} source The source that will be replaced
   */
  var parse = function parse(source) {
    try {
      if (typeof source !== 'string') throw new Error('The value needs to be a string.');

      return replace(source);
    } catch (e) {
      console.error('emojer: ' + e.message);
    }
  };

  /**
   * Call the methods to initialize the application
   */
  var init = function init() {
    if (isBrowser()) {
      createStyle();
    }
  };

  /**
   * Run app, run!
   */
  init();

  exports.addEmoji = addEmoji;
  exports.setConfigs = setConfigs;
  exports.parse = parse;

  Object.defineProperty(exports, '__esModule', {
    value: true
  });

})));
