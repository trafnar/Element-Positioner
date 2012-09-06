// Generated by CoffeeScript 1.3.3
(function() {

  jQuery.fn.getSelector = function() {
    var draggableRegex, name, node, parent, path, realNode, siblings;
    if (this.length !== 1) {
      throw 'Requires one element.';
    }
    node = this;
    draggableRegex = /\s(ui-draggable(-dragging)?)/g;
    while (this.length) {
      realNode = node[0];
      name = realNode.localName;
      if (!name) {
        break;
      }
      name = name.toLowerCase();
      if (realNode.id) {
        return "" + name + " #" + realNode.id + (path ? ">" + path : void 0);
      } else if (realNode.className.replace(draggableRegex, '')) {
        name += "." + (realNode.className.replace(draggableRegex, '').split(/\s+/).join('.'));
      }
      parent = node.parent();
      siblings = parent.children(name);
      if (siblings.length > 1) {
        name += ":nth-child(" + (siblings.index(node) + 1) + ")";
      }
      path = "" + name + (path ? '>' + path : '');
      node = parent;
    }
    return path;
  };

}).call(this);
