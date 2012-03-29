
window.EndPointTable = Backbone.View.extend({
  el: '#endpoint',

  events: {
    "change #endpoints": "gotoEndPointTable",
    "change #versions": "gotoVersion",
    "click #per_page_settings": "reloadWith",
    "click #page_selector": "reloadWith",
    "click .add_filter": "newFilter",
    "click .endpoint_search": "reloadWith",
    "submit form#endpoint_filters": "reload",
    "click .endpoint_reset": "reset"
  },

  initialize: function() {
    this.getCurrentParams();
    this.getBaseUrl();
    this.loadFilters();
  },

  newFilter: function(e) {
    e.preventDefault();
    var ef = new EndPointFilter({end_point_table: this}).render();
    $('#filter_container').append(ef.el);
  },

  loadFilters: function() {
    var self = this;
    var filters = _.map(this.current_params, function(k) {
      if (k.indexOf('.') > -1) {
        var ef = new EndPointFilter({end_point_table: self}).render();
        ef.loadFor(k, self.current_params[k]);
        $('#filter_container').append(ef.el);
        return k;
      }
      return null;
    });

    _.each(filters, function(k) {
      if (k) 
        self.removeParam(k);
    });

  },

  getCurrentParams: function() 
  {
      var vars = [], hash;
      if (window.location.href.indexOf('?') > -1) {
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++)
        {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
      }
      this.current_params = vars;
  },

  setParam: function(key, value) {
    if (!this.current_params[key])
      this.current_params.push(key);
    this.current_params[key] = value;
  },

  removeParam: function(key) {
    var i = this.current_params.indexOf(key);
    if (i > -1) {
      this.current_params.splice(i,1);
      delete this.current_params[key];
    }
  },


  serializeFilter: function() {
    var self = this;
    $('#endpoint_filters .endpoint_filter').each(function(f) {
      var column    = $('.column_select option:selected', this).val();
      var operator  = $('*[name='+column+'_operator] option:selected', this).val();
      var value     = $('*[name='+column+'_value] option:selected, input[name='+column+'_value]', this).val();
      var key       = column + "." + operator;

      var encryptor = $('*[name='+column+'_unencrypted]:checked' , this.el);
      if (!!encryptor.length) {
        var app_id     = encryptor.attr('data-ai');
        var secret_key = encryptor.attr('data-sk');
        var value      = Crypto.SHA1(app_id + value + secret_key);
      }

      self.setParam(key, value);
    });
  },
  
  getBaseUrl: function() {
    this.base_url = window.location.href.split('?')[0];
  },

  gotoVersion: function(e) {
    var o = $(e.target).find('option:selected');
    this.base_url = o.attr('value');
    this.reload();
  },

  gotoEndPointTable: function(e) {
    var o = $(e.target).find('option:selected');
    window.location = o.attr('value');
  },

  reloadWith: function(e) {
    e.preventDefault();
    var self= this;
    var param_string = $(e.target).attr('href'), hash;
    variables = param_string.slice(param_string.indexOf('?') + 1).split('&');
    _.each(variables, function(var_s) {
      hash = var_s.split('=');
      self.setParam(hash[0], hash[1]);
    });
    this.reload();
  },
  
  reload: function() {
    var self = this;
    
    this.serializeFilter();
    
    var param_string = _.map(this.current_params, function(k) {
      return k + "=" + self.current_params[k];
    }).join("&");
    
    var url = this.base_url + "?" + param_string;
    // console.log(url);
    
    window.location = url;
    return false;
  },
  
  reset: function() {
    window.location = this.base_url;
  }
  
});

_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};
  
window.EndPointFilter = Backbone.View.extend({
  
  events: {
    "change .column_select" : "columnSelected"
    ,"click .remove_filter": "remove"
    // ,"change select": "serialize"
    // ,"blur input": "serialize"
  },
  
  current_key: null,
  end_point_table: null,
  
  loadFor: function(key_op, value) {
    var key_op_arr = key_op.split('.');
    var key = key_op_arr[0];
    var op =  key_op_arr[1];
    $('.column_select', this.el).val(key);
    $('*[name='+key+'_operator]', this.el).val(op);
    $('*[name='+key+'_value]', this.el).val(value);
    this.columnSelected();
  },

  columnSelected: function() {
    var column = $('.column_select option:selected', this.el).val();
    $('.operator_value', this.el).hide();
    $('.operator_value[data-for='+column+']', this.el).css({ "display":"inline" });
  },

  render: function() {
    var html = _.template($("#filter_template").html())({ filter: $('.endpoint_filter').length });
    $(this.el).html(html); 
    
    this.columnSelected();
    
       
    return this;
  },
  
  removeFilter: function() {
    if (this.current_key)
      this.options.end_point_table.removeParam(this.current_key);
      
    this.remove();
  }

});





