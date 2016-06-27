onPage('editais index', function() {
  var $form = $('#editais-form');
  function enviaForm() {
    $form.submit();
  }

  $('#search').on('input', enviaForm);

  $('#editais-form').on('ajax:send', function() {
    $('#lista-editais').addClass('carregando');
  })

  $('#editais-form').on('ajax:complete', function() {
    $('#lista-editais').removeClass('carregando');
  })
});
