theme-list
  theme-item(each='{theme, i in themes}' theme='{ theme }' list_view='{ parent }' key='theme_{ theme.id }' groups_url='{ opts.groups_url }')
  .add(show='{ opts.creatable }')
    a(href='#' onclick='{ startEdit }' hide='{ editing }') 追加
    theme-form(on_submit='{ create }' show='{ editing }' groups_url='{ opts.groups_url }')
  
  script(type='text/coffeescript').
    @editing = false
    
    @on 'mount', (ev)=>
      ajax = $.ajax
        url: opts.themes_url
        type: 'GET'
      ajax.done (data, status, xhr)=>
        @themes = data
        console.log @themes
        @update()

    @remove = (theme)=>
      @themes = _.reject @themes, (t)->
        t.id == theme.id
      @update()

    @create = (ev)=>
      data = $(ev.target).serialize()
      ajax = $.ajax
        url: opts.themes_url
        type: 'POST'
        data: data
      ajax.done (data, status, xhr)=>
        theme = data
        @themes.push theme

    @startEdit = (ev)=>
      @editing = true
      false

    @doneEdit = (ev)=>
      @editing = false
      @update()
        

theme-item
  .theme
    .id id: { theme.id }
    .show(hide='{ editing }')
      .name name: { theme.name }
      .group group: { theme.group.name }
      .private private: { theme.private ? '✔' : '✗' }
      a(show='{ theme.editable }' href='#' onclick='{ startEdit }') 変更
    theme-form(theme='{ theme }' on_submit='{ patch }' show='{ editing }' groups_url='{ opts.groups_url }')
    .control(show='{ theme.editable }')
      form(onsubmit='{ remove }')
        button 削除

  script(type='text/coffeescript').
    {@theme, @list_view} = opts
    @editing = false

    @patch = (ev)=>
      data = $(ev.target).serialize()
      ajax = $.ajax
        url: @theme.url
        type: 'PATCH'
        data: data
      ajax.done (data, status, xhr)=>
        @theme = data

    @remove = (ev)=>
      return unless confirm '本当に削除しますか？'

      ajax = $.ajax
        url: @theme.url
        type: 'DELETE'
      ajax.done (data, status, xhr)=>
        @list_view.remove(@theme)

    @startEdit = (ev)=>
      @editing = true
      false

    @doneEdit = (ev)=>
      @editing = false
      @update()
      

theme-form
  form(onsubmit='{ onsubmit }')
    .name name:
      input(name='theme[name]' type='text' value='{ theme.name }')
    .group group:
      select(name='theme[group_id]')
        option(value='') 所属グループ
        option(each='{ group in groups }' value='{ group.id }' selected='{ group.id == parent.theme.group_id }') { group.name }
        
    .private private:
      input(name='theme[private]' type='hidden'   value='0')
      input(name='theme[private]' type='checkbox' value='1' checked='{ theme.private }')
    button 決定
    a(href='#' onclick='{ cancelEdit }') キャンセル

  script(type='text/coffeescript').
    {@theme} = opts
    is_new = !@theme
    
    @theme ||= {}
    
    @on 'mount', (ev)=>
      ajax = $.ajax
        url: opts.groups_url
        type: 'GET'
      ajax.done (data, status, xhr)=>
        @groups = data
        @update()

    @onsubmit = (ev)=>
      opts.on_submit(ev).done (data, status, xhr)=>
        @theme = if is_new then {} else data
        @resetEdit()
        @parent.doneEdit()

    @resetEdit = (ev)=>
      @['theme[name]'].value = @theme.name || ''
      @['theme[private]'].checked = !!@theme.private
      _.each @['theme[group_id]'].children, (o)=>
        o.selected = o.value && parseInt(o.value) == @theme.group_id
        

    @cancelEdit = (ev)=>
      @resetEdit()
      @parent.doneEdit()
