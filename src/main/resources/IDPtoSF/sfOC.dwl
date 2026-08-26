%dw 2.0
output application/json
var auxRut = payload.prompts.clientRUT.answer.value replace /\./ with ("") replace ("\"") with "" 
---
{
	"esOrden": payload.prompts.ordenCompra.answer.value,
	"numeroOrden": payload.prompts.nroOrdenCompra.answer.value,
	"fecha": payload.prompts.fecha.answer.value,
	"rutVolcan": payload.prompts.vendorRUT.answer.value replace /\./ with (""),
	"nombreVolcan": payload.prompts.vendorName.answer.value,
	"rutSolicitante": if (!isEmpty(vars.sfDomain)) vars.sfDomain.VM_RUT__c
					else if (auxRut == "96848750-7" or auxRut == "90209000-2" or auxRut =="77524300-7")
					  	"0"
					  else
					  	auxRut,	
	"nombreSolicitante": if (!isEmpty(vars.sfDomain)) vars.sfDomain.VM_Nombre_Cliente__c
							else if ((vars.sender contains ("ebema")) or (lower(vars.subject) contains ("ebema"))) "Ebema S.A."
							else payload.prompts.clientName.answer.value,
	"direccionDespachar": if (((vars.sender contains ("ebema")) or (vars.sender contains ("easy")) or (vars.sender contains ("cencosud"))) 
							and !isEmpty(vars.bodyContent) and vars.direccionDespachoBody !="0") 
								vars.direccionDespachoBody
							else payload.prompts.direccionDestinatario.answer.value,
	"canal": "0",
	"incoterms1": payload.prompts.incoterm1.answer.value,
	"condicionPago": payload.prompts.condicionPago.answer.value,
	"nombreDestinatario": payload.prompts.nombreDestinatario.answer.value,
	"fechaValidez": payload.prompts.fechaValidez.answer.value,
	"items": ((read(payload.prompts.tabla.answer.value default "", "application/json")  default []) as Array)
	    map ((item, index) -> 
	    	item update {
	    		case .codigo -> (($ splitBy (" "))[0] splitBy ("/"))[0]
		        case .precioTotal -> (($ replace /(?<=\d)[\.,](?=\d{3}(\D|$))/ with "") replace "," with "." replace /\$/ with "") as Number default 0
		        case .precioUnitario -> (($ replace /(?<=\d)[\.,](?=\d{3}(\D|$))/ with "") replace "," with "." replace /\$/ with "") as Number default 0
		        case .cantidad -> (($ replace /(?<=\d)[\.,](?=\d{3}(\D|$))/ with "") replace "," with "." replace /\$/ with "") as Number default 1
		}),
	"conversationId": vars.message.conversationId,
	"source": "Correo",
	"subject": vars.subject,
	"fileName": vars.attachment.name
}