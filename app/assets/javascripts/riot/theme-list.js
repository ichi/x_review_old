
riot.tag('theme-list', '<theme-item each="{theme, i in themes}" theme="{ theme }" list_view="{ parent }" key="theme_{ theme.id }"></theme-item> <div show="{ opts.creatable }" class="add"><a href="#" onclick="{ startEdit }" hide="{ editing }">追加</a> <theme-form on_submit="{ create }" show="{ editing }"></theme-form> </div>', function(opts) {this.editing = false;

this.on('mount', (function(_this) {
  return function(ev) {
    var ajax;
    ajax = $.ajax({
      url: opts.url,
      type: 'GET'
    });
    return ajax.done(function(data, status, xhr) {
      _this.themes = data;
      console.log(_this.themes);
      return _this.update();
    });
  };
})(this));

this.remove = (function(_this) {
  return function(theme) {
    _this.themes = _.reject(_this.themes, function(t) {
      return t.id === theme.id;
    });
    return _this.update();
  };
})(this);

this.create = (function(_this) {
  return function(ev) {
    var ajax, data;
    data = $(ev.target).serialize();
    ajax = $.ajax({
      url: opts.url,
      type: 'POST',
      data: data
    });
    return ajax.done(function(data, status, xhr) {
      var theme;
      theme = data;
      return _this.themes.push(theme);
    });
  };
})(this);

this.startEdit = (function(_this) {
  return function(ev) {
    _this.editing = true;
    return false;
  };
})(this);

this.doneEdit = (function(_this) {
  return function(ev) {
    _this.editing = false;
    return _this.update();
  };
})(this);

});
riot.tag('theme-item', '<div class="theme"> <div class="id">id: { theme.id }</div> <div hide="{ editing }" class="show"> <div class="name">name: { theme.name }</div> <div class="private">private: { theme.private ? \'✔\' : \'✗\' }</div><a show="{ theme.editable }" href="#" onclick="{ startEdit }">変更</a> </div> <theme-form theme="{ theme }" on_submit="{ patch }" show="{ editing }"></theme-form> <div show="{ theme.editable }" class="control"> <form onsubmit="{ remove }"> <button>削除</button> </form> </div> </div>', function(opts) {this.theme = opts.theme, this.list_view = opts.list_view;

this.editing = false;

this.patch = (function(_this) {
  return function(ev) {
    var ajax, data;
    data = $(ev.target).serialize();
    ajax = $.ajax({
      url: _this.theme.url,
      type: 'PATCH',
      data: data
    });
    return ajax.done(function(data, status, xhr) {
      return _this.theme = data;
    });
  };
})(this);

this.remove = (function(_this) {
  return function(ev) {
    var ajax;
    if (!confirm('本当に削除しますか？')) {
      return;
    }
    ajax = $.ajax({
      url: _this.theme.url,
      type: 'DELETE'
    });
    return ajax.done(function(data, status, xhr) {
      return _this.list_view.remove(_this.theme);
    });
  };
})(this);

this.startEdit = (function(_this) {
  return function(ev) {
    _this.editing = true;
    return false;
  };
})(this);

this.doneEdit = (function(_this) {
  return function(ev) {
    _this.editing = false;
    return _this.update();
  };
})(this);

});
riot.tag('theme-form', '<form onsubmit="{ onsubmit }"> <div class="name">name: <input name="theme[name]" type="text" value="{ theme.name }"> </div> <div class="private">private: <input name="theme[private]" type="hidden" value="0"> <input name="theme[private]" type="checkbox" value="1" __checked="{ theme.private }"> </div> <button>決定</button><a href="#" onclick="{ cancelEdit }">キャンセル</a> </form>', function(opts) {this.theme = opts.theme;

this.theme || (this.theme = {});

this.onsubmit = (function(_this) {
  return function(ev) {
    return opts.on_submit(ev).done(function(data, status, xhr) {
      _this.theme = data;
      _this.resetEdit();
      return _this.parent.doneEdit();
    });
  };
})(this);

this.resetEdit = (function(_this) {
  return function(ev) {
    return _this['theme[name]'].value = _this.theme.name || '';
  };
})(this);

this.cancelEdit = (function(_this) {
  return function(ev) {
    _this.resetEdit();
    return _this.parent.doneEdit();
  };
})(this);

});