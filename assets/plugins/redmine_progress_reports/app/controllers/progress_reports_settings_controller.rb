# encoding: UTF-8
#
# ﻿Empresa desarrolladora: Fujitsu Technology Solutions S.A. - http://ts.fujitsu.com - Carlos Barroso Baltasar
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

class ProgressReportsSettingsController < ApplicationController

	#ruta y nombre por defecto de la plantilla
	RUTA_PLANTILLA_DEFECTO = 'plugins/redmine_progress_reports/report_template.ods'
	#ruta y nombre por defecto para la plantilla subida (se le da otro nombre para capturar posibles excepciones)
	RUTA_TMP_PLANTILLA = 'plugins/redmine_progress_reports/uploaded_template_tmp.ods'

	#Método que descarga la plantilla en uso
	def download
		if File.file?(RUTA_PLANTILLA_DEFECTO)#compruebo que exista la plantilla
			send_file RUTA_PLANTILLA_DEFECTO, :type => 'application/ods', :disposition => 'attachment'
		else
			flash[:error] = l(:error_download_file)
			redirect_to :back
		end
	end

	def upload
		if request.post?
			#Archivo subido por el usuario.
			file = request.raw_post
			#Verifica que el archivo tenga una extensión correcta.
			if (params[:content_type].include?("opendocument.spreadsheet"))
				#LLamar a método
				if upload_file_temporal(file)
					redirect_to :back
				end
			else
				flash[:error] = l(:error_format_file)
				redirect_to :back
			end
		end
	end

	def upload_file_temporal(file)
		result = true
		begin
			#Primero borro antiguo 
			File.delete(RUTA_TMP_PLANTILLA) if File.file?(RUTA_TMP_PLANTILLA)
			# Almacenamos temporalmente el archivo seleccionado
			result = File.open(RUTA_TMP_PLANTILLA, "wb") { |f| f.write(file) }
			flash[:error] = l(:error_upload_file) if(!result)
		rescue Errno::ENOENT => e 
			flash[:error] = l(:error_upload_file)
			result = false
		end
		result
	end

end
