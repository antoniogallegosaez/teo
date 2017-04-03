# encoding: UTF-8
#
# ﻿Empresa desarrolladora: Fujitsu Technology Solutions S.A.
#
# Autor: Junta de Andalucía
# Derechos de explotación propiedad de la Junta de Andalucía.
#
# Éste programa es software libre: usted tiene derecho a redistribuirlo y/o modificarlo bajo los términos de la Licencia EUPL European Public License publicada por el organismo IDABC de la Comisión Europea, en su versión 1.0. o posteriores.
#
# Éste programa se distribuye de buena fe, pero SIN NINGUNA GARANTÍA, incluso sin las presuntas garantías implícitas de USABILIDAD o ADECUACIÓN A PROPÓSITO CONCRETO. Para mas información consulte la Licencia EUPL European Public License.
#
# Usted recibe una copia de la Licencia EUPL European Public License junto con este programa, si por algún motivo no le es posible visualizarla, puede consultarla en la siguiente URL: http://ec.europa.eu/idabc/servlets/Docb4f4.pdf?id=31980
#
# You should have received a copy of the EUPL European Public License along with this program. If not, see
# http://ec.europa.eu/idabc/servlets/Docbb6d.pdf?id=31979
#
# Vous devez avoir reçu une copie de la EUPL European Public License avec ce programme. Si non, voir http://ec.europa.eu/idabc/servlets/Doc5a41.pdf?id=31983
#
# Sie erhalten eine Kopie der europäischen EUPL Public License zusammen mit diesem Programm. Wenn nicht, finden Sie da http://ec.europa.eu/idabc/servlets/Doc9dbe.pdf?id=31977
#


module RedmineOppm

  class ProgressReportsHooks < Redmine::Hook::ViewListener
    #ruta y nombre por defecto de la plantilla
    RUTA_PLANTILLA_DEFECTO = 'plugins/redmine_progress_reports/report_template.ods'
    #ruta y nombre por defecto para la plantilla subida (se le da otro nombre para capturar posibles excepciones)
    RUTA_TMP_PLANTILLA = 'plugins/redmine_progress_reports/uploaded_template_tmp.ods'

  	render_on :view_issues_show_description_bottom, partial: 'issues/progress_reports_generate_link'

    def progress_reports_settings_controller_plugin_hook(context = {})
      result = false;
      filename = context[:filename]
      # Formato del fichero
      if (filename.include?(".") && filename.split(".").last.eql?("ods"))
        result = upload_delete_rename_file
      end
      result
    end

    def upload_delete_rename_file
      result = true
      #Crear el archivo en el directorio. Guardamos el resultado en una variable, será true si el archivo se ha guardado correctamente.
      begin
        #Primero borro antiguo 
        if (File.file?(RUTA_PLANTILLA_DEFECTO) && File.file?(RUTA_TMP_PLANTILLA)) 
          File.delete(RUTA_PLANTILLA_DEFECTO)
          #Luego renombro el archivo que se ha subido
          File.rename(RUTA_TMP_PLANTILLA, RUTA_PLANTILLA_DEFECTO)
        else
          result = false
        end
      rescue Errno::ENOENT => e 
        Rails.logger.error + l(:error_upload_file) + e 
        result = false
      end
      result
    end

  end

end