// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var MaasiveWeb = {};

MaasiveWeb.init_show_secret_key_links = function() {
  $('a[data-secret-key-url]').click(function(e) {
    e.preventDefault();
    var el = $(this);
    el.parent().load(el.attr('data-secret-key-url'));
    el.parent().html("loading...");
  });
};

$(function() {
  MaasiveWeb.init_show_secret_key_links();
});

function JPShizzleScrollWizzle(inner_el, outer_el, scroll_bar) {
  var self = this;
  this.inner_el             = inner_el;
  this.outer_el             = outer_el;
  this.scroll_bar           = scroll_bar;
  this.scroll_bar_container = scroll_bar.parent();

  if ((outer_el.width() / inner_el.width() * 100) >= 98) {
    this.scroll_bar_container.hide();
  } else {
    var windowTop = $(window).scrollTop();
    $(window).bind('mousewheel', function(event) {
        if (windowTop == $(window).scrollTop()) {
          var current_value = parseInt(inner_el.css('margin-left'), 0);
          var target_value  = current_value + event.wheelDelta;
          if (target_value > 0) {
            target_value = 0;
          } else if (target_value < ( 0 - ( inner_el.width() - outer_el.width() ) ) ) {
            target_value = ( 0 - ( inner_el.width() - outer_el.width() ));
          }
          inner_el.css({'margin-left': target_value });
          self.moveScrollBar(self);
        }
        windowTop = $(window).scrollTop();
    });

    this.scroll_bar.css({'width': (outer_el.width() / inner_el.width() * 100) + "%" });
    this.scroll_bar.bind('mousedown', function(e) { self.startScrollBar(e, self); });
  }
}

JPShizzleScrollWizzle.prototype.startScrollBar = function(event, self) {
  event.preventDefault();
  self.dragStart = event.pageX - parseInt(self.scroll_bar.css('margin-left'),0);
  $(document).bind('mouseup', function(e) { self.endScrollBar(e, self); });
  $(document).bind('mousemove', function(e) { self.dragScrollBar(e, self); });
};

JPShizzleScrollWizzle.prototype.dragScrollBar = function(event, self) {
  var target_value = event.pageX - self.dragStart;
  if (target_value < 0) {
    target_value = 0;
  } else if (target_value > self.scroll_bar_container.width() - self.scroll_bar.width() ) {
    target_value = self.scroll_bar_container.width() - self.scroll_bar.width();
  }
  self.scroll_bar.css({'margin-left': target_value });
  self.moveParent(self);
};

JPShizzleScrollWizzle.prototype.moveParent = function(self) {
  current_precentage       = parseInt( self.scroll_bar.css('margin-left'),0) / ( self.scroll_bar_container.width() - self.scroll_bar.width() );
  possible_range_of_parent = self.inner_el.width() - self.outer_el.width();
  target_margin            = (0 - possible_range_of_parent * current_precentage);
  
  self.inner_el.css({'margin-left': target_margin });
};

JPShizzleScrollWizzle.prototype.moveScrollBar = function(self) {
  current_precentage       = parseInt( self.inner_el.css('margin-left'),0) / ( self.inner_el.width() - self.outer_el.width() );
  possible_range_of_parent = self.scroll_bar_container.width() - self.scroll_bar.width();
  target_margin            = (0 - possible_range_of_parent * current_precentage);
  
  self.scroll_bar.css({'margin-left': target_margin });
};

JPShizzleScrollWizzle.prototype.endScrollBar = function(event) {
  $(document).unbind('mousemove');
};
  
  
DRMagicLabelWizzler = function(selector) {
  var input_el = $(selector+" input, "+selector+" textarea");
  var label_el = $(selector+" label");
  
  var w      = label_el.width();
  var space  = input_el.width();
  var anchor = label_el.position().left;
  
  function slideOver() {
    // var move = anchor + space - w;
    var move = 0 - w - 30;
    label_el.css({
      left: move
    });
  }
  function slideBack() { 
    if (input_el.val() == '') {
      label_el.css({
        left: anchor
      });
    }
  };

  if (input_el.val() != "") { slideOver(); }
  
  input_el.focus(slideOver);
  input_el.focusout(slideBack);
  
  setTimeout(function() {
    if (input_el.val() != "") { slideOver(); }
  }, 1000); // check for autofill in a second
};


toggleManageAccount = function() {
  $('.manage_account_dd').toggle();
  $('.manage_account').toggleClass('showing');  
};

$(document).ready(function() {
  // $('.add_developer').hide();
  $('.add_developer_button').click(function(e) {
    e.preventDefault();
    $('.add_developer').slideToggle();
  });

  if (!!$('.ep_table').length) {
	  new JPShizzleScrollWizzle($('.ep_table'), $('.ep_scroll_container'), $('.ep_scrollbar'));	
  }	

  // Hide NEWS FEED when user clicks outside
  $(document).bind('click', function(e) {                                                               
    var $clicked = $(e.target);                                                                         
    if (! $clicked.hasClass("manage_account_dd") && ! $clicked.hasClass("manage_account") && $(".manage_account_dd").css('display') == 'block')
      toggleManageAccount();                                                
  });  

  // Toggle NewsFeed
  $('.manage_account').click(function(){
    toggleManageAccount();
  });    
  

  $('#invite_request_invite_code_input').css('padding', '0px').hide();

  $('#show_invite_code').click(function(){
    $('#invite_request_invite_code_input').css('padding', '10px 0px').show();
    DRMagicLabelWizzler('#invite_request_invite_code_input');
    $(this).hide();
  });  
  
                                
  

});
