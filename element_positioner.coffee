class window.ElementPositioner
  constructor : () ->
    @draggable = null
    @active = false
    @controlPanel = @createControlPanel()

  activate : (elements) =>
    @elements = elements
    @removeClickBindingsFromElements()
    @initDraggables()
    @elements.css cursor: 'move'
    @active = true
    @displayResult()

  deactivate : (closePanel = false) =>
    @destroyControlPanel() if closePanel
    @restoreClickBindingsToElements()
    @draggable.draggable("destroy")
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
      selector = if e.attr('id')? then "##{e.attr('id')}" else e.getSelector()
      left = "#{parseInt(e.css('left'), 10)}px"
      top = "#{parseInt(e.css('top'), 10)}px"
      z = e.css('z-index')
      styleString += "#{selector} { left: #{left}; top: #{top}; z-index: #{z}; }\n"
    @controlPanel.find('.element-positioner-result').text styleString

  removeClickBindingsFromElements : () =>
    @elements.unbind('click')

  restoreClickBindingsToElements : () =>
    @elements.unbind('click') # removes added ones
    # todo - actually restore

  createControlPanel : () =>
    panel = $('<div>').attr('id', 'element-positioner-panel')
    handle = $('<div>').addClass('element-positioner-handle')
    result = $('<pre>').addClass('element-positioner-result')
    selector = $('<input>').addClass('element-positioner-selector').change (e) =>
      target = $(e.target)
      @activate($(target.val()))
      target.remove()

    panel.append handle
    panel.append selector
    panel.append result

    panel.draggable handle: handle
    
    $('body').append panel

    return panel

  destroyControlPanel : () =>
    @controlPanel.remove()


