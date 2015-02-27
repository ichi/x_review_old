
riot.tag('theme-list', '<theme-item each="{theme, i in themes}" theme="{ theme }" list_view="{ parent }" key="theme_{ theme.id }" groups_url="{ opts.groups_url }" signed_in="{ signed_in }"></theme-item> <div show="{ signed_in }" class="add"><a href="#" onclick="{ startEdit }" hide="{ editing }">追加</a> <theme-form on_submit="{ create }" show="{ editing }" groups_url="{ opts.groups_url }" signed_in="{ signed_in }"></theme-form> </div>', function(opts) {this.editing = false;

this.signed_in = parseInt(opts.signed_in);

this.on('mount', (function(_this) {
  return function(ev) {
    var ajax;
    ajax = $.ajax({
      url: opts.themes_url,
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
      url: opts.themes_url,
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
riot.tag('theme-item', '<div class="theme"> <div class="id">id: { theme.id }</div> <div hide="{ editing }" class="show"> <div class="name">name: { theme.name }</div> <div class="group">group: { theme.group.name }</div> <div class="private">private: { theme.private ? \'✔\' : \'✗\' }</div><a show="{ theme.editable }" href="#" onclick="{ startEdit }">変更</a> </div> <theme-form theme="{ theme }" on_submit="{ patch }" show="{ editing }" groups_url="{ opts.groups_url }" sigend_in="{ opts.signed_in }"></theme-form> <div show="{ theme.editable }" class="control"> <form onsubmit="{ remove }"> <button>削除</button> </form> </div> </div>', function(opts) {this.theme = opts.theme, this.list_view = opts.list_view;

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
riot.tag('theme-form', '<form onsubmit="{ onsubmit }"> <div class="name">name: <input name="theme[name]" type="text" value="{ theme.name }"> </div> <div class="group">group: <select name="theme[group_id]"> <option value="">所属グループ</option> <option each="{ group in groups }" value="{ group.id }" __selected="{ group.id == parent.theme.group_id }">{ group.name }</option> </select> </div> <div class="private">private: <input name="theme[private]" type="hidden" value="0"> <input name="theme[private]" type="checkbox" value="1" __checked="{ theme.private }"> </div> <button>決定</button><a href="#" onclick="{ cancelEdit }">キャンセル</a> </form>', function(opts) {var is_new;

this.theme = opts.theme;

is_new = !this.theme;

this.theme || (this.theme = {});

return opts.signed_in;

this.on('mount', (function(_this) {
  return function(ev) {
    var ajax;
    ajax = $.ajax({
      url: opts.groups_url,
      type: 'GET'
    });
    return ajax.done(function(data, status, xhr) {
      _this.groups = data;
      return _this.update();
    });
  };
})(this));

this.onsubmit = (function(_this) {
  return function(ev) {
    return opts.on_submit(ev).done(function(data, status, xhr) {
      _this.theme = is_new ? {} : data;
      _this.resetEdit();
      return _this.parent.doneEdit();
    });
  };
})(this);

this.resetEdit = (function(_this) {
  return function(ev) {
    _this['theme[name]'].value = _this.theme.name || '';
    _this['theme[private]'].checked = !!_this.theme["private"];
    return _.each(_this['theme[group_id]'].children, function(o) {
      return o.selected = o.value && parseInt(o.value) === _this.theme.group_id;
    });
  };
})(this);

this.cancelEdit = (function(_this) {
  return function(ev) {
    _this.resetEdit();
    return _this.parent.doneEdit();
  };
})(this);

});