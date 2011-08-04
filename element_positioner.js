var ElementPositionEditor = function(options){
	this.options = $.extend({
		elements : null,
		cssPrefix : null
	},options);
	
	this.draggable = null;
	this.active = false;
	this.bindActivationKeypress();
		
};

ElementPositionEditor.prototype.bindActivationKeypress = function(){
  $('body').keypress($.proxy(function(e){
    if(e.charCode == 101){
			if(this.active){
				this.stop();
			}else{
				this.start();
			}
		}
  },this));
};

ElementPositionEditor.prototype.start = function(){
	this.removeClickBindingsFromElements();
	this.draggable = this.options.elements.draggable({stack : '*'});
	this.active = true;
};

ElementPositionEditor.prototype.stop = function(){
	this.restoreClickBindingsToElements();
	this.draggable.draggable("option","disabled",true);
	this.active = false;
	this.dumpCSS();
};

ElementPositionEditor.prototype.dumpCSS = function(){
	var styleString = "";
 	this.options.elements.each($.proxy(function(i,e){
 			e = $(e);
 	    styleString += this.options.cssPrefix + '#' + e.attr('id') + '{' + 'left:' + e.css('left') + ';' + 'top:' + e.css('top') + ';' + 'z-index:' + e.css('z-index') + ';' + '}'+"\n";
 	  },this));
 	  console.log(styleString);
};

ElementPositionEditor.prototype.removeClickBindingsFromElements = function(){
	this.options.elements.unbind('click');
};

ElementPositionEditor.prototype.restoreClickBindingsToElements = function(){
	// todo
};
