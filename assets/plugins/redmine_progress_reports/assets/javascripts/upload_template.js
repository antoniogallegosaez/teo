/* Redmine - project management software
   Copyright (C) 2006-2015  Jean-Philippe Lang */

function addFile(inputEl, file, eagerUpload) {

  //var attachmentId = 1;

  var fileSpan = $('<span>', { id: 'progress_reports_template' });

  fileSpan.append(
      $('<input>', { type: 'text', 'class': 'filename readonly', name: 'progress_reports_template[filename]', readonly: 'readonly'} ).val(file.name));

  if(eagerUpload) {
    //ajaxUpload(file, attachmentId, fileSpan, inputEl);
    ajaxUpload(file, fileSpan, inputEl);
  }

  //return attachmentId;
  return true;
}

addFile.nextAttachmentId = 1;

//function ajaxUpload(file, attachmentId, fileSpan, inputEl) {
function ajaxUpload(file, fileSpan, inputEl) {

  function onLoadstart(e) {
    fileSpan.removeClass('ajax-waiting');
    fileSpan.addClass('ajax-loading');
    $('input:submit', $(this).parents('form')).attr('disabled', 'disabled');
  }

  function onProgress(e) {
    if(e.lengthComputable) {
      this.progressbar( 'value', e.loaded * 100 / e.total );
    }
  }

  //function actualUpload(file, attachmentId, fileSpan, inputEl) {
  function actualUpload(file, fileSpan, inputEl) {
    ajaxUpload.uploading++;

    //uploadBlob(file, $(inputEl).data('upload-path'), attachmentId, {
      uploadBlob(file, $(inputEl).data('upload-path'), {
        loadstartEventHandler: onLoadstart.bind(progressSpan),
        progressEventHandler: onProgress.bind(progressSpan)
      })
      .done(function(result) {
        progressSpan.progressbar( 'value', 100 ).remove();
        fileSpan.find('input.description, a').css('display', 'inline-block');
      })
      .fail(function(result) {
        progressSpan.text(result.statusText);
      }).always(function() {
        ajaxUpload.uploading--;
        fileSpan.removeClass('ajax-loading');
        //var form = fileSpan.parents('form');
        //if (form.queue('upload').length == 0 && ajaxUpload.uploading == 0) {
        //  $('input:submit', form).removeAttr('disabled');
        //}
        //form.dequeue('upload');
      });
  }

  var progressSpan = $('<div>').insertAfter(fileSpan.find('input.filename'));
  progressSpan.progressbar();
  fileSpan.addClass('ajax-waiting');

  var maxSyncUpload = $(inputEl).data('max-concurrent-uploads');

  if(maxSyncUpload == null || maxSyncUpload <= 0 || ajaxUpload.uploading < maxSyncUpload)
    //actualUpload(file, attachmentId, fileSpan, inputEl);
    actualUpload(file, fileSpan, inputEl);
  else
    //$(inputEl).parents('form').queue('upload', actualUpload.bind(this, file, attachmentId, fileSpan, inputEl));
  $(inputEl).parents('form').queue('upload', actualUpload.bind(this, file, fileSpan, inputEl));
}

ajaxUpload.uploading = 0;

function removeFile() {
  $(this).parent('span').remove();
  return false;
}

//function uploadBlob(blob, uploadUrl, attachmentId, options) {
function uploadBlob(blob, uploadUrl, options) {
  var actualOptions = $.extend({
    loadstartEventHandler: $.noop,
    progressEventHandler: $.noop
  }, options);

  //uploadUrl = uploadUrl + '?attachment_id=' + attachmentId;
  if (blob instanceof window.File) {
    //uploadUrl += '&filename=' + encodeURIComponent(blob.name);
    uploadUrl += '?filename=' + encodeURIComponent(blob.name);
    uploadUrl += '&content_type=' + encodeURIComponent(blob.type);
  }

  return $.ajax(uploadUrl, {
    type: 'POST',
    contentType: 'application/octet-stream',
    beforeSend: function(jqXhr, settings) {
      jqXhr.setRequestHeader('Accept', 'application/js');
      // attach proper File object 
      settings.data = blob;
    },
    xhr: function() {
      var xhr = $.ajaxSettings.xhr();
      xhr.upload.onloadstart = actualOptions.loadstartEventHandler;
      xhr.upload.onprogress = actualOptions.progressEventHandler;
      return xhr;
    },
    data: blob,
    cache: false,
    processData: false
  });
}

function addInputFiles(inputEl) {
  //var clearedFileInput = $(inputEl).clone().val('');

  if ($.ajaxSettings.xhr().upload && inputEl.files) {
    // upload files using ajax
    uploadAndAttachFiles(inputEl.files, inputEl);
    //$(inputEl).remove();
  } else {
    // browser not supporting the file API, upload on form submission
    var attachmentId;
    var aFilename = inputEl.value.split(/\/|\\/);
    //attachmentId = addFile(inputEl, { name: aFilename[ aFilename.length - 1 ] }, false);
    addFile(inputEl, { name: aFilename[ aFilename.length - 1 ] }, false);
    //if (attachmentId) {
      //$(inputEl).attr({ name: 'attachments[' + attachmentId + '][file]', style: 'display:none;' }).appendTo('#attachments_' + attachmentId);
    //}
    $(inputEl).attr({ name: 'progress_reports_template[file]', style: 'display:none;' });
}

  //clearedFileInput.insertAfter('#attachments_fields');
}

function uploadAndAttachFiles(files, inputEl) {

  var maxFileSize = $(inputEl).data('max-file-size');
  var maxFileSizeExceeded = $(inputEl).data('max-file-size-message');
  var fileTypeError = $(inputEl).data('file-type-message'); 

  var sizeExceeded = false;
  var wrongType = false;
  $.each(files, function() {
    if (this.size && maxFileSize != null && this.size > parseInt(maxFileSize)) {sizeExceeded=true;}
    if (!this.type.includes("opendocument.spreadsheet")) {wrongType=true;}
  });

  if(sizeExceeded || wrongType){
    if (sizeExceeded) {
      window.alert(maxFileSizeExceeded);
    } else { // WrongType
      window.alert(fileTypeError);
    }
    $(inputEl).val('') // Eliminamos el fichero
  } else {
    $.each(files, function() {addFile(inputEl, this, true);});
  }

  //if (sizeExceeded) {
  //  window.alert(maxFileSizeExceeded);
  //} else if (wrongType){
  //  window.alert(fileTypeError);
  //} else {
  //  $.each(files, function() {addFile(inputEl, this, true);});
  //}
}

function handleFileDropEvent(e) {

  $(this).removeClass('fileover');
  blockEventPropagation(e);

  if ($.inArray('Files', e.dataTransfer.types) > -1) {
    uploadAndAttachFiles(e.dataTransfer.files, $('input:file.file_selector'));
  }
}

function dragOverHandler(e) {
  $(this).addClass('fileover');
  blockEventPropagation(e);
}

function dragOutHandler(e) {
  $(this).removeClass('fileover');
  blockEventPropagation(e);
}

function setupFileDrop() {
  if (window.File && window.FileList && window.ProgressEvent && window.FormData) {

    $.event.fixHooks.drop = { props: [ 'dataTransfer' ] };

    $('form div.box').has('input:file').each(function() {
      $(this).on({
          dragover: dragOverHandler,
          dragleave: dragOutHandler,
          drop: handleFileDropEvent
      });
    });
  }
}

$(document).ready(setupFileDrop);
