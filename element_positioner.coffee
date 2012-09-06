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
      
      left = parseInt(e.css('left'), 10)
      top = parseInt(e.css('top'), 10)
      left = if isNaN(left) then 'auto' else "#{left}px"
      top = if isNaN(top) then 'auto' else "#{top}px"
      z = e.css('z-index')

      styleString += "#{selector} { left: #{left}; top: #{top}; z-index: #{z}; }\n"
    @controlPanel.find('.element-positioner-result').text styleString

  removeClickBindingsFromElements : () =>
    @elements.unbind('click')

  restoreClickBindingsToElements : () =>
    @elements.unbind('click') # removes added ones
    # todo - actually restore click events

  createControlPanel : () =>

    previewSelector = (e) =>
      target = $(e.target)
      val = target.val()
      $('.element-positioner-selected').removeClass('element-positioner-selected')
      $(val).addClass('element-positioner-selected')

    acceptSelector = (e) =>
      target = $(e.target)
      @activate($(target.val()))
      target.remove()
      $('.element-positioner-selected').removeClass('element-positioner-selected')

    # create a css class for to highlight selected items
    style = $('<style>').attr('type', 'text/css')
    style.html('.element-positioner-selected{ background-color:yellow; outline:2px solid yellow; opacity:.8}')
    $('head').append(style)

    # create the panel, it's drag handle and results area and selector input
    panel = $('<div>').attr('id', 'element-positioner-panel')
    handle = $('<div>').addClass('element-positioner-handle')
    result = $('<textarea>').addClass('element-positioner-result').click (e) => $(e.target).select()
    selector = $('<input>').addClass('element-positioner-selector')

    selector.change acceptSelector
    selector.keyup previewSelector
    panel.append handle
    panel.append selector
    panel.append result
    panel.draggable handle: handle
    $('body').append panel
    return panel

  destroyControlPanel : () =>
    @controlPanel.remove()

