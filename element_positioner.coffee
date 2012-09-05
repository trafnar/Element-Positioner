class window.ElementPositioner
  constructor : () ->
    @elements = $('p')
    @draggable = null
    @active = false

  activate : () =>
    @removeClickBindingsFromElements()
    @draggable = @elements.draggable({stack : '*'})
    @active = true

  deactivate : () =>
    @restoreClickBindingsToElements()
    @draggable.draggable "option", "disabled", true
    @active = false
    @displayResult()

  displayResult : () =>
    styleString = "";
    @elements.each (i,e) =>
      e = $(e)
      selector = if e.attr('id')? then "##{e.attr('id')}" else e.getPath()
      styleString += "#{selector} { left: #{e.css('left')}; top: #{e.css('top')}; z-index: #{e.css('z-index')}; }\n"
    console.log styleString

  removeClickBindingsFromElements : () =>
    @elements.unbind('click');

  restoreClickBindingsToElements : () =>
    # todo

