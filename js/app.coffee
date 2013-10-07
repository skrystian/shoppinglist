$ ->
    class Item extends Backbone.Model
        #url: '/'
        defaults:
            name: 'product name'
            done: false

    class List extends Backbone.Collection
        #url: 'tasks'
        model: Item
        localStorage: new Store "todo"


    class Todo extends Backbone.View
        initialize: ->
            _.bindAll
            console.log "Todo"
            @model.bind 'remove', @removeItemFromModel

        render: =>
            console.log "Todo render"
            $(@el).html("<div class='item'><div class='task-name'> " + @model.get('name') + "</div><button class='removeBtn tiny'></button></div>")

        removeItemFromModel: =>
            $(@el).remove()

        remove: ->
            console.log 'remove'
            @model.destroy()

        events:
            'click .removeBtn': 'remove'

    class TodoApp extends Backbone.View

        initialize: ->
            _.bindAll
            @list = new List
            @list.bind 'add', @onAddNewItemToList
            @list.bind 'remove add', @onChangeModel
            @list.fetch()
            $("#list").css("height", ($(window).height() - 155) + "px")
            @onChangeModel()

        onClickAddItem: ->
            item = new Item
            item.set name: $('input').val()
            $('input').val("")
            @list.add item
            item.save()
        onAddNewItemToList: (item) ->
            todo = new Todo model: item
            $('#list').append todo.render()
        onChangeModel: =>
            $(".numberOfTasks").html("<b>" + @list.length + "</b>" + " tasks")

        events:
            'click #addItemBtn': 'onClickAddItem'
            'click .removeBtn': 'onClickRemoveBtn'


    todoApp = new TodoApp(el: $('#todoApp'))

    #nice scroll
    $("#list").niceScroll({touchbehavior:false, cursorcolor:"rgba(100,100,100,0.8)", cursoropacitymin:0.2, cursoropacitymax:0.5, cursorwidth:8, horizrailenabled:false})
    #orientation
    updateScroll = ->
        $("#list").css("height", ($(window).height() - 155) + "px")
        $("#list").getNiceScroll().resize()
        $("#list").getNiceScroll().resize().show()
    $(window).bind('orientationchange', updateScroll)


    #api tests
    ###
    onDeviceReady = ->
        $('h3').html "device ready"
        onSuccess = (acceleration) ->
            $('h3').html acceleration.x + ' ' + acceleration.y + ' ' + acceleration.z

        onError = ->
            $("h3").html("error")

        options = { frequency: 100 }
        watchID = navigator.accelerometer.watchAcceleration(onSuccess, onError, options)


    document.addEventListener('deviceready', onDeviceReady, false)




    $("h3").html("onDeviceReady")
    onSuccess = (contacts) ->
        $('h3').html('success find: ' + contacts.length + ' contacts')
    onError = ->
        $("h3").html("error")

    options = new ContactFindOptions()
    options.filter = ''
    options.multiple = true
    fields = ['displayName', 'name']
    navigator.contacts.find(fields, onSuccess, onError, options)

    ###


    ###
    for i in [1..numberOfLvl] by 1
        $("#listlvl" + i.toString() + " > li").mouseover ->
            $(this).find('.leftMenuItemsCounter').hide()
            $(this).find('.leftMenuItemsConfig').show()
        $("#listlvl" + i.toString() + " > li").mouseout ->
            $(this).find('.leftMenuItemsConfig').hide()
            $(this).find('.leftMenuItemsCounter').show()

        $("#listlvl" + i.toString() + " > li").bind "tap", ->
            clearSelected($(this).parent().attr 'id')
            lvl = $(this).parent().attr 'id'
            lvl = lvl.substr(lvl.length - 1, 1)
            itemName = $(this).find('a').html()
            switch parseInt(lvl)
                when 1 then setContainerTitle('showContainer', itemName)
                when 2 then setContainerTitle('eventContainer', itemName)
                when 3 then setContainerTitle('folderContainer', itemName)
                else
            $(this).addClass "selectedItem"
   
    ###

    # color tip         

    $("#listlvl1 img, #listlvl2 img, #listlvl3 img, .colorTip").mouseover ->
        colorTip = $(this).parent().find('.colorTip')

        setColorTipPosition = ->
            $(colorTip).css('margin-left', '-' + colorTip.width() + 'px')
        setTimeout(setColorTipPosition, 0)

    window.socket = new WebSocket('ws://hydrav2.active-loop.com:8020', 'json')

    socket.onopen = ->
        socket.send 'hello'

    socket.onmessage = (s) ->
        console.log('hydra SPS: ' + s)

    socket.onerror = (err) ->
        console.log('hydra SPS Err: ' + err)

    socket.onclose = ->
        console.log 'close connection with SPS'


