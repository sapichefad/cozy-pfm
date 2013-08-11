BaseView = require '../lib/base_view'
BankAccessModel = require '../models/bank_access'

module.exports = class NewBankView extends BaseView

    template: require('./templates/new_bank')

    el: 'div#add-bank-window'

    events:
        'click #btn-add-bank-save' : "saveBank"

    saveBank: (event) ->
        event.preventDefault()

        view = @

        button = $ event.target
        console.log button

        oldText = button.html()
        button.addClass "disabled"
        button.html "verifying... <img src='/loader.gif' />"

        data =
            login: $("#inputLogin").val()
            pass: $("#inputPass").val()
            bank: $("#inputBank").val()

        console.log "save bank access: "
        console.log data

        bankAccess = new BankAccessModel data

        bankAccess.save data,
            success: (model, response, options) ->

                button.html "sent successfully ... <img src='/loader.gif' />"

                hide = () ->
                    $("#add-bank-window").modal("hide")
                    button.removeClass "disabled"
                    button.html oldText
                
                setTimeout hide, 500
                
                window.activeObjects.trigger "new_access_added_successfully", model
                
            error: (model, xhr, options) ->
                console.log "Error :" + xhr

                button.html "error..."

                alert "Sorry, there was an error. Please refresh and try again."

    getRenderData: ->
        banks: window.collections.banks.models