class window.ElementPositioner
  constructor : (selector = null) ->
    @draggable = null
    @active = false
    @controlPanel = @createControlPanel(selector)
    @activate($(selector)) if selector?


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
      selector = @getSelector(e)
      left = Math.round parseFloat(e.css('left'), 10)
      top = Math.round parseFloat(e.css('top'), 10)
      left = parseFloat(e.css('left'), 10)
      top = parseFloat(e.css('top'), 10)
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

  createControlPanel : (selector) =>

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
    selectorInput = $('<input>').addClass('element-positioner-selector')

    panel.append handle
    unless selector?
      selectorInput.change acceptSelector
      selectorInput.keyup previewSelector
      panel.append selectorInput
    panel.append result
    panel.draggable handle: handle
    $('body').append panel
    return panel

  destroyControlPanel : () =>
    @controlPanel.remove()

  getSelector : (node) =>
    return false if node.length !=1
    draggableRegex = /(\s)?ui-draggable(-dragging)?/g
    while node.length
      realNode = node[0]
      name = realNode.localName
      break if !name
      name = name.toLowerCase()
      className = realNode.className.replace(draggableRegex, '')
      if realNode.id
        return "##{realNode.id}#{if path then '>' + path else ''}"
      else if className
        name += ".#{className.split(/\s+/).join('.')}"
      parent = node.parent()
      siblings = parent.children(name)
      name += ":nth-child(#{siblings.index(node) + 1})" if siblings.length > 1
      path = "#{name}#{if path then '>' + path else ''}"
      node = parent
    return path

