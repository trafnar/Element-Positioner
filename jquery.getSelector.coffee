jQuery.fn.getSelector = () ->

  throw 'Requires one element.' if this.length !=1

  node = this
  draggableRegex = /\s(ui-draggable(-dragging)?)/g

  while this.length
    realNode = node[0]
    name = realNode.localName
    break if !name

    name = name.toLowerCase()

    if realNode.id
      return "#{name} ##{realNode.id}#{">#{path}" if path}"
    else if realNode.className.replace(draggableRegex, '')
      name += ".#{realNode.className.replace(draggableRegex, '').split(/\s+/).join('.')}"

    parent = node.parent()
    siblings = parent.children(name)
    name += ":nth-child(#{siblings.index(node) + 1})" if siblings.length > 1
    path = "#{name}#{if path then '>' + path else ''}"
    node = parent

  return path
