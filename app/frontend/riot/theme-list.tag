theme-list
  theme-item(each='{theme, i in themes}' theme='{ theme }' list_view='{ parent }' key='theme_{ theme.id }')
  .add(show='{ opts.creatable }')
    a(href='#' onclick='{ startEdit }' hide='{ editing }') 追加
    theme-form(on_submit='{ create }' show='{ editing }')
  
  script(type='text/coffeescript').
    @editing = false
    
    @on 'mount', (ev)=>
      ajax = $.ajax
        url: opts.url
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
        url: opts.url
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
      .private private: { theme.private ? '✔' : '✗' }
      a(show='{ theme.editable }' href='#' onclick='{ startEdit }') 変更
    theme-form(theme='{ theme }' on_submit='{ patch }' show='{ editing }')
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
    .private private:
      input(name='theme[private]' type='hidden'   value='0')
      input(name='theme[private]' type='checkbox' value='1' checked='{ theme.private }')
    button 決定
    a(href='#' onclick='{ cancelEdit }') キャンセル

  script(type='text/coffeescript').
    {@theme} = opts
    @theme ||= {}

    @onsubmit = (ev)=>
      opts.on_submit(ev).done (data, status, xhr)=>
        @theme = data
        @resetEdit()
        @parent.doneEdit()

    @resetEdit = (ev)=>
      @['theme[name]'].value = @theme.name || ''

    @cancelEdit = (ev)=>
      @resetEdit()
      @parent.doneEdit()
