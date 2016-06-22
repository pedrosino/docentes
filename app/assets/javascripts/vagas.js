onPage('vagas index', function() {
  var $form = $('#vagas-form');
  function enviaForm() {
    $form.submit();
  }

  $('#search').on('input', enviaForm);

  $('#vagas-form').on('ajax:send', function() {
    $('#lista-vagas').addClass('carregando');
  })

  $('#vagas-form').on('ajax:complete', function() {
    $('#lista-vagas').removeClass('carregando');
  })
});
