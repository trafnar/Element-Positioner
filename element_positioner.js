var ElementPositioner = function(options){
	this.options = $.extend({
		elements : null,
		cssPrefix : ''
	},options);
	
	this.draggable = null;
	this.active = false;
	this.bindActivationKeypress();
		
};

ElementPositioner.prototype.bindActivationKeypress = function(){
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

ElementPositioner.prototype.start = function(){
	this.removeClickBindingsFromElements();
	this.draggable = this.options.elements.draggable({stack : '*'});
	this.active = true;
};

ElementPositioner.prototype.stop = function(){
	this.restoreClickBindingsToElements();
	this.draggable.draggable("option","disabled",true);
	this.active = false;
	this.dumpCSS();
};

ElementPositioner.prototype.dumpCSS = function(){
	var styleString = "";
 	this.options.elements.each($.proxy(function(i,e){
 			e = $(e);
 	    styleString += this.options.cssPrefix + '#' + e.attr('id') + '{' + 'left:' + e.css('left') + ';' + 'top:' + e.css('top') + ';' + 'z-index:' + e.css('z-index') + ';' + '}'+"\n";
 	  },this));
 	  console.log(styleString);
};

ElementPositioner.prototype.removeClickBindingsFromElements = function(){
	this.options.elements.unbind('click');
};

ElementPositioner.prototype.restoreClickBindingsToElements = function(){
	// todo
};
