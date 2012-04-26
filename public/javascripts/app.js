!function($) {
  $(function() {

    if($('.new-decision').length) {
      $('.new-decision .add').click(function() {
        $('<input id="title" type="text" name="possibilities[]" class="input-xlarge possibility">')
          .insertBefore($('.new-decision .help-block'))
        return false
      })
      $('.new-decision .create').click(function() {
        var org = $('.new-decision input[name="org"]').val()

        $('.new-decision .create').attr('disabled', true)
        $('form .alert-error').slideUp()
        $.post('/' + org, $('form').serialize(), function(res) {
          if (typeof res.error != 'undefined') {
            $('form .alert-error span').html( ' ' + res.error.message)
            $('form .alert-error').slideDown()
            $('.new-decision .create').attr('disabled', false)
          } else {
            $('.decisions').load('/' + org + ' .decisions', function() {
              $('.new-decision .create').attr('disabled', false)
            })
          }
          console.log(res)
        })

        return false
      })
    }


    if($('.possibilities').length) {

      function attach() {
        $('.vote').click(function() {
          var $this = $(this), 
              org = $('input[name="org"]').val(),
              _id = $('input[name="_id"]').val()

          $this.attr('disabled', true)

          $.post('/' + org + '/' + _id, { index: $this.data('index') }, function(res) {
            if (typeof res.error != 'undefined') {
              $('.alert-error span').html( ' ' + res.error.message)
              $('.alert-error').slideDown()
            } else {
              $('.wrapper').load('/' + org + '/' + _id + ' .possibilities', function() {
                attach()
              })
            }
            console.log(res)
          })
        })
      }

      attach()
    }

  })
}(window.jQuery);