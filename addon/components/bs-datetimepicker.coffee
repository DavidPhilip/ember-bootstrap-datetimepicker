
`import Ember from 'ember';`

computed = Ember.computed
datetimepickerDefaultConfig = Ember.$.fn.datetimepicker.defaults
isDatetimepickerConfigKeys = Ember.keys(datetimepickerDefaultConfig)

bsDateTimePickerComponent = Ember.Component.extend(
  classNames: ["bs-datetimepicker-component"]
  textFieldClass: Ember.TextField
  textFieldName: computed.alias("elementId")
  date: null
  bsDateTimePicker: null
  
  # computed options
  minDate: datetimepickerDefaultConfig["minDate"]
  maxDate: datetimepickerDefaultConfig["maxDate"]
  disabledDates: []
  enabledDates: []
  disabled: false
  open: false
  forceDateOutput: false
  
  _initDatepicker: ( ->
    self = this
    bsDateTimePicker = @$(".datetimepicker").datetimepicker(@_buildConfig())
    bsDateTimePickerFn = bsDateTimePicker.data("DateTimePicker")
    @set "bsDateTimePicker", bsDateTimePickerFn
    bsDateTimePickerFn.setDate self.get("date")
    
    @$('input.floatlabel').floatlabel
      slideInput: false
      labelStartTop: '10px'
    
    bsDateTimePicker.on "dp.change", (ev) ->
      if Ember.isNone(ev.date)
        self.set "date", `undefined`
      else
        if self.forceDateOutput
          self.set "date", ev.date.toDate()
        else
          self.set "date", ev.date

    @_disabledObserver()
    self.get("bsDateTimePicker").show() if self.get("open")
  ).on("didInsertElement")
  
  _disabledObserver: ( ->
    if @get("disabled")
      @get("bsDateTimePicker").disable()
    else
      @get("bsDateTimePicker").enable()
  ).observes("disabled")
  
  _openObserver: ( ->
    if @get("open")
      @get("bsDateTimePicker").show()
    else
      @get("bsDateTimePicker").hide()
  ).observes("open")
  
  _minDateObserver: ( ->
    @get("bsDateTimePicker").setMinDate @get("minDate")
  ).observes("minDate")
  
  _maxDateObserver: ( ->
    @get("bsDateTimePicker").setMaxDate @get("maxDate")
  ).observes("maxDate")
  
  _disabledDatesObserver: ( ->
    @get("bsDateTimePicker").setDisabledDates @get("disabledDates")
  ).observes("disabledDates")
  
  _enabledDatesObserver: ( ->
    @get("bsDateTimePicker").setEnabledDates @get("enabledDates")
  ).observes("enabledDates")
  
  _dateObserver: ( ->
    @get("bsDateTimePicker").setDate @get("date")
  ).observes("date")
  
  _destroyDatepicker: ( ->
    @get("bsDateTimePicker").destroy()
  ).on("willDestroyElement")
  
  _buildConfig: ->
    config = {}
    i = 0

    while i < isDatetimepickerConfigKeys.length
      config[isDatetimepickerConfigKeys[i]] = @get(isDatetimepickerConfigKeys[i])
      i++
    config

  actions:
    toggleOpen: ->
      @toggleProperty "open"
)

computedProps = [
  "minDate"
  "maxDate"
  "disabledDates"
  "enabledDates"
]

newClassConfig = {}
i = 0

while i < isDatetimepickerConfigKeys.length
  newClassConfig[isDatetimepickerConfigKeys[i]] = datetimepickerDefaultConfig[isDatetimepickerConfigKeys[i]]  unless computedProps.contains(isDatetimepickerConfigKeys[i])
  i++
  
bsDateTimePickerComponent.reopen newClassConfig

`export default bsDateTimePickerComponent;`

