/* This file is part of Jeedom.
*
* Jeedom is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Jeedom is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Jeedom. If not, see <http://www.gnu.org/licenses/>.
*/

/* This file is part of NextDom.
*
* NextDom is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* NextDom is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with NextDom. If not, see <http://www.gnu.org/licenses/>.
*
* @Support <https://www.nextdom.org>
* @Email   <admin@nextdom.org>
* @Authors/Contributors: Sylvaner, Byackee, cyrilphoenix71, ColonelMoutarde, edgd1er, slobberbone, Astral0, DanoneKiD
*/

/**
 * Entry point
 */
var allWells = $('.setup-content');
allWells.hide();

$(document).ready(function () {
  var navListItems = $('div.setup-panel div a');
  var allWells = $('.setup-content');

  $('#jqueryLoadingDiv').hide();

  navListItems.click(function (e) {
    e.preventDefault();
    var target = $($(this).attr('href'));
    var item = $(this);

    if (!item.hasClass('disabled')) {
      navListItems.removeClass('primary-bg btn-primary');
      navListItems.addClass('btn-default');
      item.addClass('btn-primary primary-bg');
      allWells.hide();
      target.show();
      target.find('input:eq(0)').focus();
    }
  });
  $('div.setup-panel div a.btn-primary').trigger('click');
});

$('#toStep2').click(function () {
  nextdom.user.login({
      username: 'admin',
      password: 'admin',
      error: function (error) {
        notify('Core', error.message, 'error');
      },
      success: function (data) {
        changeFirstUseStatus();
      }
  });
});

$('#toStep3').click(function () {
  var newPassword = $('#in_change_password').val();
  if (newPassword !== '') {
    if (newPassword === $('#in_change_passwordToo').val()) {
      updateUserPassword(newPassword)
    } else {
      notify('Erreur', '{{Les deux mots de passe ne sont pas identiques !}}', 'error')
    }
  } else {
    notify('Erreur', '{{Veuillez saisir un mot de passe ...}}', 'error')
  }
});

$('#toStep4').click(function () {
  var username = $('#in_login_username_market').val();
  var password = $('#in_login_password_market').val();
  nextdom.config.save({
    configuration: {'market::username': username, 'market::password': password},
    error: function (error) {
      notify('Core', error.message, 'error');
    },
    success: function () {
      nextdom.repo.test({
        repo: 'market',
        error: function (error) {
          notify('Core', error.message, 'error');
        },
        success: function () {
          goToNextStep('#toStep4');
        }
      });
    }
  });
});

$('#toStep5').click(function () {
  var radios = document.getElementsByName('theme');
  var config = '';
  for (var i = 0; i < radios.length; ++i) {
    if (radios[i].checked == true) {
      changeThemeColors(radios[i].value,false);
      goToNextStep('#toStep5');
    }
  }
});

$('#toStep6').click(function () {
  var profil = $('.firstUse-Page').getValues('.userAttr')[0];
  nextdom.user.saveProfils({
      profils: profil,
      error: function (error) {
          notify("Erreur", error.message, 'error');
      },
      success: function () {
        goToNextStep('#toStep6');
      }
  });
});

$('#backStep1').click(function () {
  goToPreviousStep('#backStep1');
});

$('#backStep2').click(function () {
  goToPreviousStep('#backStep2');
});

$('#backStep3').click(function () {
  goToPreviousStep('#backStep3');
});

$('#backStep4').click(function () {
  goToPreviousStep('#backStep4');
});

$('#backStep5').click(function () {
  goToPreviousStep('#backStep5');
});

$('#skipStep4').click(function () {
  goToNextStep('#toStep4');
});

$('#finishConf').click(function () {
  window.location = '/';
});

$("input[name=themeWidget]").on('click', function (event) {
    var radio = $(this).val();
    $('.userAttr[data-l2key="widget::theme"]').value(radio);
});

function goToNextStep(_step) {
  var curStep = $(_step).closest('.setup-content');
  var curStepBtn = curStep.attr('id');
  var nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children('a');
  var curInputs = curStep.find('input[type="text"],input[type="url"]');
  isValid = true;

  $('.form-group').removeClass('has-error');
  for (var i = 0; i < curInputs.length; i++) {
    if (!curInputs[i].validity.valid) {
      isValid = false;
      $(curInputs[i]).closest('.form-group').addClass('has-error');
    }
  }
  if (isValid) {
    nextStepWizard.removeAttr('disabled').trigger('click');
  }
}

function goToPreviousStep(_step) {
  var curStep = $(_step).closest('.setup-content');
  var curStepBtn = curStep.attr('id');
  var nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().prev().children('a');

  var curInputs = curStep.find('input[type="text"],input[type="url"]');
  var isValid = true;

  $('.form-group').removeClass('has-error');
  for (var i = 0; i < curInputs.length; i++) {
    if (!curInputs[i].validity.valid) {
      isValid = false;
      $(curInputs[i]).closest('.form-group').addClass('has-error');
    }
  }
  if (isValid) {
    nextStepWizard.removeAttr('disabled').trigger('click');
  }
}

/**
 * Get first user and update his password
 * @param newPassword
 */
function updateUserPassword(newPassword) {
  nextdom.user.get({
    error: function (data) {
      notify('Core', data.message, 'error');
    },
    success: function (data) {
      var user = data;
      user.password = newPassword;
      nextdom.user.saveProfils({
        profils: user,
        error: function (error) {
          notify('Core', error.message, 'error');
        },
        success: function () {
          notify('Core', '{{Mot de passe changé avec succès !}}', 'success');
          goToNextStep('#toStep3');
        }
      });
    }
  });
}

/**
 * Change firstUse status for next page load
 */
function changeFirstUseStatus() {
  nextdom.config.save({
    configuration: {'nextdom::firstUse': 0},
    error: function (error) {
      notify('Core', error.message, 'error');
    },
    success: function () {
      goToNextStep('#toStep2');
    }
  });

}
