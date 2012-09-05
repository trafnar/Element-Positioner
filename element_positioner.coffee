class window.ElementPositioner
  constructor : (@elements) ->
    @draggable = null
    @active = false
    @controlPanel = @createControlPanel()

  activate : () =>
    @removeClickBindingsFromElements()
    @initDraggables()
    @elements.css cursor: 'move'
    @active = true
    @displayResult()

  deactivate : () =>
    @restoreClickBindingsToElements()
    @destroyControlPanel()
    @draggable.draggable "option", "disabled", true
    @active = false
    @elements.css cursor: 'inherit'
    @displayResult()

  initDraggables : () =>
    @draggable = @elements.draggable
      stack: '*'
      drag: @displayResult

  displayResult : () =>
    styleString = "";
    @elements.each (i,e) =>
      e = $(e)
      selector = if e.attr('id')? then "##{e.attr('id')}" else e.getPath()
      left = "#{parseInt(e.css('left'), 10)}px"
      top = "#{parseInt(e.css('top'), 10)}px"
      z = e.css('z-index')
      styleString += "#{selector} { left: #{left}; top: #{top}; z-index: #{z}; }\n"
    @controlPanel.find('.element-positioner-result').text styleString

  removeClickBindingsFromElements : () =>
    @elements.unbind('click');

  restoreClickBindingsToElements : () =>
    # todo

  createControlPanel : () =>
    panel = $('<div>').attr('id', 'element-positioner-panel')
    handle = $('<div>').addClass('element-positioner-handle')
    result = $('<pre>').addClass('element-positioner-result')
    selector = $('<input>').addClass('element-positioner-selector').change (e) =>
      target = $(e.target)
      @deactivate()
      @elements = $(target.val())
      @activate()

    panel.append handle
    panel.append selector
    panel.append result
    panel.draggable handle: handle
    $('body').append panel

  destroyControlPanel : () =>


