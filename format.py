import re
import subprocess

pattern = re.compile(
     r'<rfn:RFNLabel\s+'
     r'(?=.*\bID="(?P<id>[^"]+)")?'
     r'(?=.*\bAssociatedControlID="(?P<assoc>[^"]+)")?'
     r'(?=.*\bCssClass="(?P<class>[^"]+)")?'
     r'(?=.*\bclass="(?P<class2>[^"]+)")?'
     r'(?=.*\bText="(?P<text>[^"]+)")?'
     r'(?=.*\bStyle="(?P<style>[^"]+)")?'
     r'(?=.*\bBorderColor="(?P<border_color>[^"]+)")?'
     r'(?=.*\bBorderWidth="(?P<border_width>[^"]+)")?'
     r'(?=.*\bBackColor="(?P<back_color>[^"]+)")?'
     r'(?=.*\bForeColor="(?P<fore_color>[^"]+)")?'
     r'(?=.*\bFont-Bold="(?P<font_bold>[^"]+)")?'
     r'(?=.*\bFont-Size="(?P<font_size>[^"]+)")?'
     r'(?=.*\bWidth="(?P<width>[^"]+)")?'
     r'(?=.*\bHeight="(?P<height>[^"]+)")?'
     r'(?=.*\bVisible="(?P<visible>[^"]+)")?'
     r'(?=.*\bEnabled="(?P<enabled>[^"]+)")?'
     r'(?=.*\bToolTip="(?P<tooltip>[^"]+)")?'
     r'(?=.*\bDisplay="(?P<display>[^"]+)")?'
     r'(?=.*\brunat="server")'
     r'[^>]*>'
     r'(?P<inner_text>.*?)'
     r'</rfn:RFNLabel>',
     re.IGNORECASE | re.DOTALL
)

style_mapping = {
     "border_color": "border-color",
     "border_width": "border-width",
     "back_color": "background-color",
     "fore_color": "color",
     "font_bold": "font-weight",
     "font_size": "font-size",
     "width": "width",
     "height": "height",
     "display": "display",
     "enabled": "pointer-events: none; opacity: 0.6",
}

def transform_label(match):
     id_attr = f' id="{match.group("id")}"' if match.group("id") else ""
     class_attr = f' class="{match.group("class") or match.group("class2")}"' if match.group("class") or match.group("class2") else ""
     for_attr = f' for="{match.group("assoc")}"' if match.group("assoc") else ''
     
     style_parts = []
    
     for asp_property, css_property in style_mapping.items():
          value = match.group(asp_property)
          if value:
               if asp_property == "font_bold" and value.lower() == "true":
                    style_parts.append(f"{css_property}: bold")
               elif asp_property == "font_size":
                    style_parts.append(f"{css_property}: {value}px")
               elif asp_property == "border_width":
                    style_parts.append(f"{css_property}: {value}px")
               elif asp_property == "enabled" and value.lower() == "false":
                    style_parts.append(css_property)
               elif asp_property == "display" and value.lower() == "none":
                    style_parts.append(f"{css_property}: none")
               else:
                    style_parts.append(f"{css_property}: {value}")
    
     if match.group("style"):
          style_parts.append(match.group("style"))
     
     style_attr = f' style="{"; ".join(style_parts)}"' if style_parts else ''
     tooltip_attr = f' title="{match.group("tooltip")}"' if match.group("tooltip") else ''
     text = match.group("text").strip() if match.group("text") else match.group("inner_text").strip()

     return f'<label{id_attr} runat="server"{for_attr}{class_attr}{style_attr}{tooltip_attr}>{text}</label>'

def convert_rfn_to_label(rfn_labels):
     converted_labels = []
     for label in rfn_labels:
          match = pattern.search(label)
          if match:
               converted_labels.append(pattern.sub(transform_label, label))
          else:
               converted_labels.append(label)
     return converted_labels

rfn_list = [
     '<rfn:RFNLabel class="etiqueta" ID="FlblPoblacion" runat="server"> Población</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="FlblProvincia" runat="server">Provincia</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblCalle" runat="server"> Calle</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblEscalera" runat="server"> Escalera</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblNumero" runat="server"> Número</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblNumFaxCentro" runat="server"> Fax</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblNumTelf" runat="server"> Teléfono</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblPiso" runat="server"> Piso</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblPoblacion" runat="server"> Población</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblPortal" runat="server"> Portal</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblProvincia" runat="server">Provincia</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblPuerta" runat="server"> Puerta</rfn:RFNLabel>',
     '<rfn:RFNLabel class="etiqueta" ID="lblVia" runat="server"> Tipo de vía</rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="FlblCodPostalCentro" AssociatedControlID="TXTCP" runat="server" Text=" C.P."></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblAtencionEnvFact" AssociatedControlID="txtAtencionEnvFact" runat="server" Text="A la atención de"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblAtencionEnvFactP" AssociatedControlID="txtAtencionEnvFactP" runat="server" Text="A la atención de"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCalleDS" AssociatedControlID="txtCalleDS" runat="server" Text="Calle"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCalleEnvFact" AssociatedControlID="txtCalleEnvFact" runat="server" Text="Calle"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCalleEnvFactP" AssociatedControlID="txtCalleEnvFactP" runat="server" Text="Calle"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCodPostalCentro" AssociatedControlID="cmbCodPostal" runat="server" Text=" C.P."></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCodPostalDS" AssociatedControlID="txtCPDS" runat="server" Text=" C.P."></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCodPostalEnvFact" AssociatedControlID="cmbCPEnvFact" runat="server" Text=" C.P."></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCodPostalEnvFactP" AssociatedControlID="cmbCPEnvFactP" runat="server" Text=" C.P."></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblCPFilial" AssociatedControlID="txtCPFilial" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblDomicilioFacturacionFilial" AssociatedControlID="txtDomicilioFacturacionFilial" runat="server"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblEmail" AssociatedControlID="txtEmailDS" runat="server" Text="Email"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblEmailEnvFact" AssociatedControlID="txtEmailEnvFact" runat="server" Text="Dirección Email"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblEmailEnvFactP" AssociatedControlID="txtEmailEnvFactP" runat="server" Text="Dirección Email"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblEscaleraDS" AssociatedControlID="txtEscaleraDS" runat="server" Text="Escalera"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblEscaleraEnvFact" AssociatedControlID="txtEscaleraEnvFact" runat="server" Text="Escalera"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblEscaleraEnvFactP" AssociatedControlID="txtEscaleraEnvFactP" runat="server" Text="Escalera"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumeroDS" AssociatedControlID="txtNumDS" runat="server" Text="Número"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumeroEnvFact" AssociatedControlID="txtNumEnvFact" runat="server" Text="Número"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumeroEnvFactP" AssociatedControlID="txtNumEnvFactP" runat="server" Text="Número"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumFaxDS" AssociatedControlID="txtNumFaxDS" runat="server" Text="Fax"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumFaxEnvFact" AssociatedControlID="txtNumFaxEnvFact" runat="server" Text="Fax"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumFaxEnvFactP" AssociatedControlID="txtNumFaxEnvFactP" runat="server" Text="Fax"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumTelfDS" AssociatedControlID="txtTelefonoDS" runat="server" Text="Teléfono"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumTelfEnvFact" AssociatedControlID="txtTelefonoEnvFact" runat="server" Text="Teléfono"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblNumTelfEnvFactP" AssociatedControlID="txtTelefonoEnvFactP" runat="server" Text="Teléfono"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblOficinaContable" AssociatedControlID="txtOficinaContable" runat="server" Text="Oficina Contable"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblOrganoGestor" AssociatedControlID="txtOrganoGestor" runat="server" Text="Órgano Gestor"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblOrganoProponente" AssociatedControlID="txtOrganoProponente" runat="server" Text="Órgano Competente"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPisoDS" AssociatedControlID="txtPisoDS" runat="server" Text="Piso"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPisoEnvFact" AssociatedControlID="txtPisoEnvFact" runat="server" Text="Piso"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPisoEnvFactP" AssociatedControlID="txtPisoEnvFactP" runat="server" Text="Piso"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPoblacionDS" AssociatedControlID="ccdPoblacionDS" runat="server" Text="Población"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPoblacionEnvFact" AssociatedControlID="ccdPoblacionEnvFact" runat="server" Text="Población"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPoblacionEnvFactP" AssociatedControlID="ccdPoblacionEnvFactP" runat="server" Text="Población"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPoblacionFilial" AssociatedControlID="txtPoblacionFilial" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPortalDS" AssociatedControlID="txtPortalDS" runat="server" Text="Portal"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPortalEnvFact" AssociatedControlID="txtPortalEnvFact" runat="server" Text="Portal"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPortalEnvFactP" AssociatedControlID="txtPortalEnvFactP" runat="server" Text="Portal"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPuertaDS" AssociatedControlID="txtPuertaDS" runat="server" Text="Puerta"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPuertaEnvFact" AssociatedControlID="txtPuertaEnvFact" runat="server" Text="Puerta"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblPuertaEnvFactP" AssociatedControlID="txtPuertaEnvFactP" runat="server" Text="Puerta"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblReferenciaDomi" AssociatedControlID="txtReferenciaDomi" runat="server" Text="Referencia"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblRefFact" AssociatedControlID="txtRefFact" runat="server" Text="Ref. Factura"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblTrabAnexo" AssociatedControlID="txtTrabAnexo" runat="server" Text="Anexo" ToolTip="Alto Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblTrabConstruccion" AssociatedControlID="txtTrabConstruccion" runat="server" Text="Construcción"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblTrabIndustria" AssociatedControlID="txtTrabIndustria" runat="server" Text="Industria"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblTrabOficina" AssociatedControlID="txtTrabOficina" runat="server" Text="Oficina" ToolTip="Bajo Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblTrabTotal" AssociatedControlID="txtTrabTotal" runat="server" Text="Total"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblUnidadTramitadora" AssociatedControlID="txtUnidadTramitadora" runat="server" Text="Unidad Tramitadora"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblViaDS" AssociatedControlID="cmbTipoViaDS" runat="server" Text="Tipo de vía"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblViaEnvFact" AssociatedControlID="cmbTipoViaEnvFact" runat="server" Text="Tipo de vía"> </rfn:RFNLabel>',
     '<rfn:RFNLabel class="lblEtiquetas" ID="lblViaEnvFactP" AssociatedControlID="cmbTipoViaEnvFactP" runat="server" Text="Tipo de vía"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="btninsertarPrueba" runat="server" Visible="True" Text="Añadir Prueba" Style="margin: 15px 0px 0px 30px;" BackColor="#009900" Font-Bold="True" BorderWidth="1" BorderColor="Black"   CssClass="lblEtiquetaBoton" Tipo="Texto" ForeColor="White" Width="110px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="btnrecargar" runat="server" Visible="True" Text="Filtrar lista" Style="margin: 0px 0px 0px 30px;" BackColor="#009900" Font-Bold="True" BorderWidth="1" BorderColor="Black" CssClass="lblEtiquetaBoton" Tipo="Texto" ForeColor="White" Width="80px" display="none"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="datosAsociadosFilial" runat="server" Text="Datos de Contacto asociados a filial"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lbCosteTotalPruebasVSI" runat="server" Text="Coste Total Pruebas VSI incluidas: " Font-Bold="True"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblActividadCentro" AssociatedControlID="ccdActividadCentro" CssClass="lblEtiquetas" runat="server" Text="CNAE"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblAltaPeligrosidad" class="lblEtiquetas" AssociatedControlID="txtAltaPeligrosidad" runat="server" Text="Alto Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblbajamultiple" runat="server" Text="Dar de baja contratos AAEE" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="175px" Enabled="false"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblBajaPeligrosidad" class="lblEtiquetas" AssociatedControlID="txtBajaPeligrosidad" runat="server" Text="Bajo Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblbobser" runat="server" Text="Búsqueda"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblbobser2" class="lblEtiquetas" AssociatedControlID="txtCtrObserv" runat="server" Text="Observaciones del contrato"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblccdPruebasExternas" runat="server" Text="Prueba" AssociatedControlID="ccdPruebasExternas" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblcifpagador" AssociatedControlID="ccdCifPagador" CssClass="lblEtiquetas" runat="server" Text="Otro Pagador"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCrearAnexo" runat="server" Text="Nuevo Anexo" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="100px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCrearAnexoAAEE" runat="server" Text="Nuevo Anexo AAEE" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="100px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCrearAnexoAnalitica" runat="server" Text="Nuevo Anexo Analiticas" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="100px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCrearAnexoRenovacion" runat="server" Text="Nuevo Anexo Renovacion" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="100px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido1Notario1" AssociatedControlID="txtCtrApellido1Notario1" class="lblEtiquetas" Text="Primer Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido1Notario2" AssociatedControlID="txtCtrApellido1Notario2" class="lblEtiquetas" Text="Primer Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido1Representante1" AssociatedControlID="txtCtrApellido1Representante1" class="lblEtiquetas" Text="Primer Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido1Representante2" AssociatedControlID="txtCtrApellido1Representante2" class="lblEtiquetas" Text="Primer Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido2Notario1" AssociatedControlID="txtCtrApellido2Notario1" class="lblEtiquetas" Text="Segundo Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido2Notario2" AssociatedControlID="txtCtrApellido2Notario2" class="lblEtiquetas" Text="Segundo Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido2Representante1" AssociatedControlID="txtCtrApellido2Representante1" class="lblEtiquetas" Text="Segundo Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrApellido2Representante2" AssociatedControlID="txtCtrApellido2Representante2" class="lblEtiquetas" Text="Segundo Apellido" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrBajaMultiple" class="lblEtiquetas" AssociatedControlID="txtCtrBajaMultiple" runat="server" Text="Observaciones de baja"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrCargoDirectivo1" AssociatedControlID="txtCtrCargoDirectivo1" class="lblEtiquetas" Text="Cargo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrCargoDirectivo2" AssociatedControlID="txtCtrCargoDirectivo2" class="lblEtiquetas" Text="Cargo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrCargoRepresentante1" AssociatedControlID="txtCtrCargoRepresentante1" class="lblEtiquetas" Text="Cargo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrCargoRepresentante2" AssociatedControlID="txtCtrCargoRepresentante2" class="lblEtiquetas" Text="Cargo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrCausaBaja" class="lblEtiquetas" AssociatedControlID="ddlCtrCausaBaja" runat="server" Text="Causa de baja"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrCausaBaja2" class="lblEtiquetas" AssociatedControlID="ddlCtrCausaBaja2" runat="server" Text="Causa de baja"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrContratoAntiguo" class="lblEtiquetas" AssociatedControlID="txtCtrContratoAntiguo" runat="server" Text="Contrato Antiguo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrContratoNuevo" class="lblEtiquetas" AssociatedControlID="txtCtrContratoNuevo" runat="server" Text="Contrato Nuevo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrDirectivo1" AssociatedControlID="ccdCtrDirectivo1" class="lblEtiquetas" Text="Directivo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrDirectivo2" AssociatedControlID="ccdCtrDirectivo2" class="lblEtiquetas"Text="Directivo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrEmailRepresentante1" AssociatedControlID="txtCtrEmailRepresentante1" class="lblEtiquetas" Text="Email" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrEmailRepresentante2" AssociatedControlID="txtCtrEmailRepresentante2" class="lblEtiquetas" Text="Email" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFecBaja" runat="server" class="lblEtiquetas" Text="Fecha de Baja"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFecBaja2" runat="server" class="lblEtiquetas" Text="Fecha de Baja"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaCliente" runat="server" Text="Por parte del Cliente"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaClienteNotario1" runat="server" Text="Notario"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaClienteNotario2" runat="server" Text="Notario"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaClienteRepresentante1" runat="server" Text="Primer Representante"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaClienteRepresentante2" runat="server" Text="Segundo Representante"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaSPFM" runat="server" Text="Por parte de Quirón Prevención"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaSPFMDirectivo1" runat="server" Text="Primer Directivo"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrFirmaSPFMDirectivo2" runat="server" Text="Segundo Directivo"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrIdentificadorRepresentante1" AssociatedControlID="txtCtrIdentificadorRepresentante1" class="lblEtiquetas" Text="DNI/CIF" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrIdentificadorRepresentante2" AssociatedControlID="txtCtrIdentificadorRepresentante2" class="lblEtiquetas" Text="DNI/CIF" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrNombreNotario1" AssociatedControlID="txtCtrNombreNotario1" class="lblEtiquetas" Text="Nombre" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrNombreNotario2" AssociatedControlID="txtCtrNombreNotario2" class="lblEtiquetas" Text="Nombre" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrNombreRepresentante1" AssociatedControlID="txtCtrNombreRepresentante1" class="lblEtiquetas" Text="Nombre" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrNombreRepresentante2" AssociatedControlID="txtCtrNombreRepresentante2" class="lblEtiquetas" Text="Nombre" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrObservBaja" class="lblEtiquetas" AssociatedControlID="txtCtrObservBaja" runat="server" Text="Observaciones de baja"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrObservBaja2" class="lblEtiquetas" AssociatedControlID="txtCtrObservBaja2" runat="server" Text="Observaciones de baja"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrPoblacionNotario1" AssociatedControlID="ccdCtrPoblacionNotario1" class="lblEtiquetas" Text="Población" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrPoblacionNotario2" AssociatedControlID="ccdCtrPoblacionNotario2" class="lblEtiquetas" Text="Población" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrPoderDirectivo1" AssociatedControlID="txtCtrPoderDirectivo1" class="lblEtiquetas" Text="Poder" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrPoderDirectivo2" AssociatedControlID="txtCtrPoderDirectivo2" class="lblEtiquetas" Text="Poder" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrPorcentajeColab" AssociatedControlID="txtCtrPorcentajeColab" CssClass="lblEtiquetas" runat="server" Text="%"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrProtocoloNotario1" AssociatedControlID="txtCtrProtocoloNotario1" class="lblEtiquetas" Text="Protocolo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrProtocoloNotario2" AssociatedControlID="txtCtrProtocoloNotario2" class="lblEtiquetas" Text="Protocolo" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblCtrTrimestreColab" AssociatedControlID="txtCtrTrimestreColab_1" runat="server" CssClass="lblEtiquetas" Text="Desde Trimestre"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescMed" AssociatedControlID="txtDescMed" runat="server" Text="%Desc. Méd."> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescMed" AssociatedControlID="txtDescMed" runat="server" Text="%Desc. Méd."> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescRecoAlta" AssociatedControlID="txtDescRecoAlta" runat="server" Text="%Desc.Reco.Alto Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescRecoBaja" AssociatedControlID="txtDescRecoBaja" runat="server" Text="%Desc.Reco.Bajo Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescTec" AssociatedControlID="txtDescTec" runat="server" Text="%Desc. Téc."> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescTec" AssociatedControlID="txtDescTec" runat="server" Text="%Desc. Téc."> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescTecHoras" AssociatedControlID="txtDescTecHoras" runat="server" Text="%Desc. Téc. Horas" Width="110px">  </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDescTecHoras" AssociatedControlID="txtDescTecHoras" runat="server" Text="%Desc. Téc. Horas"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDesde1" class="lblEtiquetas" runat="server" Text="Desde"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDesde2" class="lblEtiquetas" runat="server" Text="Desde"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDesde3" class="lblEtiquetas" runat="server" Text="Desde"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblDesde4" class="lblEtiquetas" runat="server" Text="Desde"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lbldiapago" AssociatedControlID="txtdiapago" CssClass="lblEtiquetas" runat="server" Text="Día de Pago"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lbleliminarIPC" runat="server" Text="Eliminar IPC" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="100px" Enabled="false"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lbleliminarIPC2" runat="server" Text="Eliminar IPC Fija" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="110px" Enabled="false"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblfact" ForeColor="Red" runat="server" Style="display: none" Text="Según los permisos que usted tiene no puede introducir la cuenta bancaria del contrato."></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFecFin" AssociatedControlID="calFecFin" CssClass="lblEtiquetas" runat="server" Text="Fecha Finalización"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFecUltReno" AssociatedControlID="calFecUltReno" CssClass="lblEtiquetas" runat="server" Text="Fecha de última Renovación"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFieldSetFactRecos" runat="server" Text="Facturación de Reconocimientos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblfiltrosCT" runat="server" Text="Filtros de búsqueda"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblfltroCT" runat="server" Text="Buscar" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="175px" Enabled="false"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFormaPago" AssociatedControlID="rblTipoPago" CssClass="lblEtiquetas" runat="server" Text="Forma de Pago"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFsAnalCompuesta" runat="server" Text="Analíticas Compuestas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFsAnalPerfil" runat="server" Text="Perfiles"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblFsAnalSimple" runat="server" Text="Analíticas Simples"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblGenerarCargoCuenta" runat="server" Text="Doc. cargo en cuenta" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="155px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblGenerarDocumentacion" runat="server" Text="Generar Documentación" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="155px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblgrabarcentro" runat="server" Text="Grabar" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="100px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblHDAnx" runat="server" Width="110px" Text="Importe Hospital Digital"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblHDCtrt" runat="server" Width="110px" Text="Importe Hospital Digital"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblHistColab" runat="server" Text="Histórico de Colaboradores" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblhistTarifa" runat="server" Text="Histórico de Tarifas" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblHorasProducto" runat="server" Text="Horas" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblHorasProductoAutonomo" runat="server" Text="Horas" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblHorasProductoBolsaHoras" runat="server" Text="Horas" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImpAnexo" runat="server" Text="Modalidades antes de Bayes"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImpContrato" runat="server" Text="Modalidades contrato"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteARTarifa" Width="70px" runat="server" Text="Alto Riesgo: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteBRTarifa" Width="70px" runat="server" Text="Bajo Riesgo: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblimporteqshd" runat="server" Width="110px" Text="Importe Hospital Digital: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteTarifa" runat="server" Text="Importe según Tarifa: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteTarifa" runat="server" Text="Importe según Tarifa: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteTarifaDescuento" runat="server" Text="Importe aplicado: " Width="110px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteTarifaDescuento" runat="server" Text="Importe aplicado: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteTarifaReco" runat="server" Text="Importe según Tarifa: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImporteTarifaRecoDescuento" runat="server" Text="Importe aplicado: "></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblImpPruebasVSI" runat="server" Text="IMPORTE TOTAL VSI PREFACTURADA " CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblIncluyeRecos" class="lblEtiquetas" AssociatedControlID="txtIncluyeRecos" runat="server" Text="Incluye"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendAnexo" runat="server" Text="Anexos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCentrosTotal" runat="server" Text="Número de centros"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCentrosTrabajo" runat="server" Text="Centros de Trabajo"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrBaja" runat="server" Text="Baja del Contrato"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrBaja2" runat="server" Text="Baja del Contrato"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrColaborador" runat="server" Text="Colaborador"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrContactos" runat="server" Text="Contactos del Cliente"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrDirEnvFact" runat="server" Text="Dirección de envío de facturas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrDomiBanc" runat="server" Text="Domiciliación Bancaria"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrFirma" runat="server" Text="Firmantes"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrIndicadores" runat="server" Text="Indicadores"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrRenoPrecios" runat="server" Text="Renovación de Precios de Concierto"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendCtrRespCap" runat="server" Text="Captación/Renovación del Contrato"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendFacturacion" runat="server" Text="Facturación"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendGrupoOtrasActividades" runat="server" Text="Actividades de formación"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendHistColab" runat="server" Text="Datos de los Colaboradores"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendHistDocumento" runat="server" Text="Anexo Renovación"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendHistTarifa" runat="server" Text="Datos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendTarificacionAutonomos" runat="server" Text="Autónomos"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendTarificacionBolsaHoras" runat="server" Text="Bolsa de Horas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendTarificacionModalidades" runat="server" Text="Modalidades"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendTarificacionProductos" runat="server" Text="Productos"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblLegendTrabTotal" runat="server" Text="Trabajadores Totales"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lbllimpiarfiltroct" runat="server" Text="Limpiar campos" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="175px" Enabled="false"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModalidades" runat="server" Text="Precios/Horas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModEPAnx" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModEPAnx" runat="server" Text="EP"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModHIAnx" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModHIAnx" runat="server" Text="HI"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModHorMed" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModHorMedDescuento" runat="server" Text="Horas Méd"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModHorMed" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModHorMedDescuento" runat="server" Text="Horas Méd"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModHorTec" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModHorTecDescuento" runat="server" Text="Horas Téc"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModHorTec" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModHorTecDescuento" runat="server" Text="Horas Téc"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModMTAnx" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModMTAnx" runat="server" Text="MT"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModRPFAnexo" class="lblEtiquetas" AssociatedControlID="txtModRPFAnexo" runat="server" Text="Importe RPF"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModRPFCtrt" class="lblEtiquetas" AssociatedControlID="txtModRPFCtrt" runat="server" Text="Importe RPF"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModSheAnx" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModSheAnx" runat="server" Text="SHE"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModSheCtrt" runat="server" Text="SHE" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModSheCtrt"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModSTAnx" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModSTAnx" runat="server" Text="ST"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModTot" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModTot" runat="server" Text="Total"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModTot" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModTot" runat="server" Text="Total"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModTOTALAnx" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModTotAnx" runat="server" Text="TOTAL"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblModTotCtrt" CssClass="lblEtiquetasPadd" AssociatedControlID="txtModTotCtrt" runat="server" Text="Total"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblMotivoDescuento" class="lblEtiquetas" AssociatedControlID="txtMotivoDescuento" runat="server" Text="Motivo de Descuento" Visible="False"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblMotivoDescuento" class="lblEtiquetas" AssociatedControlID="txtMotivoDescuento" runat="server" Text="Motivo de Descuento" Visible="False"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblNumpedidoF" AssociatedControlID="txtNumPedidoF" CssClass="lblEtiquetas" runat="server" Text="Nº Pedido Fijo"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblNumpedidoF" AssociatedControlID="txtNumPedidoF" CssClass="lblEtiquetas" runat="server" Text="Nº Pedido Fijo"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblNumpedidoV" AssociatedControlID="txtNumPedidoV" CssClass="lblEtiquetas" runat="server" Text="Nº Pedido Variable"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblNumpedidoV" AssociatedControlID="txtNumPedidoV" CssClass="lblEtiquetas" runat="server" Text="Nº Pedido Variable"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblOtrasPruebasExternas" runat="server" Text="Resto de pruebas VSI"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPeriPago" AssociatedControlID="rblPeriPago" CssClass="lblEtiquetas" runat="server" Text="Periodo de Facturación"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPlazoPago" AssociatedControlID="cmbPlazoPago" CssClass="lblEtiquetas" runat="server" Text="Plazo de Pago"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecio1" class="lblEtiquetas" runat="server" Text="Precio"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecio2" class="lblEtiquetas" runat="server" Text="Precio"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecio3" class="lblEtiquetas" runat="server" Text="Precio"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecio4" class="lblEtiquetas" runat="server" Text="Precio"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioMedicoProducto" runat="server" Text="Médico" Width="50px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioMedicoProductoAutonomo" runat="server" Text="Médico" Width="50px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioMedicoProductoBolsaHoras" runat="server" Text="Médico" Width="50px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioProducto" runat="server" Text="Precio" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioProductoAutonomo" runat="server" Text="Precio" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioProductoBolsaHoras" runat="server" Text="Precio" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioTecnicoProducto" runat="server" Text="Técnico" Width="50px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioTecnicoProductoAutonomo" runat="server" Text="Técnico" Width="50px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioTecnicoProductoBolsaHoras" runat="server" Text="Técnico" Width="50px"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioTotalProducto" runat="server" Text="Total" Width="50px" Font-Bold="True"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioTotalProductoAutonomo" runat="server" Text="Total" Width="50px" Font-Bold="True"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblPrecioTotalProductoBolsaHoras" runat="server" Text="Total" Width="50px" Font-Bold="True"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblProvinciaDS" AssociatedControlID="cmbProvinciaDS" CssClass="lblEtiquetas" runat="server" Text="Provincia"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblProvinciaEnvFact" AssociatedControlID="cmbProvinciaEnvFact" CssClass="lblEtiquetas" runat="server" Text="Provincia"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblProvinciaEnvFactP" AssociatedControlID="cmbProvinciaEnvFactP" CssClass="lblEtiquetas" runat="server" Text="Provincia"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblProvinciaFilial" AssociatedControlID="txtProvinciaFilial" CssClass="lblEtiquetas" runat="server"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblProvinciaNotario1" AssociatedControlID="cmbProvinciaNotario1" CssClass="lblEtiquetas" runat="server" Text="Provincia"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblProvinciaNotario2" AssociatedControlID="cmbProvinciaNotario2" CssClass="lblEtiquetas" runat="server" Text="Provincia"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRAPAnexo" class="lblEtiquetas" AssociatedControlID="txtRAPAnexo" runat="server" Text="Alto Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRAPCtrt" class="lblEtiquetas" AssociatedControlID="txtRAPCtrt" runat="server" Text="Alto Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRBPAnexo" class="lblEtiquetas" AssociatedControlID="txtRBPAnexo" runat="server" Text="Bajo Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRBPCtrt" class="lblEtiquetas" AssociatedControlID="txtRBPCtrt" runat="server" Text="Bajo Riesgo"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblReconocimientosPrefacturados" class="lblEtiquetas" AssociatedControlID="txtModRPF" runat="server" Text="Importe Reconocimientos Prefact."> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRecosVSI" runat="server" Text="Reconocimientos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRPFAnexo" runat="server" Text="Reconocimientos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRPFCtrato" runat="server" Text="Reconocimientos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRPFIncluidosAnexo" class="lblEtiquetas" AssociatedControlID="txtRPFIncluidosAnexo" runat="server" Text="Incluye"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblRPFIncluidosCtrt" class="lblEtiquetas" AssociatedControlID="txtRPFIncluidosCtrt" runat="server" Text="Incluye"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblTarifa" class="lblEtiquetas" runat="server" Text="Tarifa"> </rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblTerminadoToVigente" runat="server" Text="Pasar a Vigente" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White" Visible="True" Width="175px" Enabled="false"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblTramos" runat="server" Text="Tramos :" Class="tituloPanelColapsable"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblVacio" runat="server" Text="lblVacio" CssClass="lblEtiquetas" ForeColor="White"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblVacioAutonomo" runat="server" Text="lblVacio" CssClass="lblEtiquetas" ForeColor="White"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="lblVacioBolsaHoras" runat="server" Text="lblVacio" CssClass="lblEtiquetas" ForeColor="White"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="RFNLabel1" runat="server" Text="Datos Organismos Públicos"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="RFNLabel10" runat="server" Text="&nbspEl precio de la MT es el sumatorio de la Subscripción a Hospital Digital y la vigilancia de la salud colectiva" ForeColor="Red" Font-Bold="True" ></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="RFNLabel2" runat="server" Text="Datos Contrato"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="RFNLabel5" runat="server" Text="Número total de Pruebas VSI en el contrato"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="RFNLabel6" AssociatedControlID="btnDescargarExcel" CssClass="lblEtiquetas" runat="server" Text="Descargar Centros de Trabajo"></rfn:RFNLabel>',
     '<rfn:RFNLabel ID="RFNLabel9" runat="server" Text="_." BackColor="Red" ForeColor="Red" Font-Bold="True" ></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblApellido1" Text="Primer Apellido" AssociatedControlID="txtApellido1" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblApellido2" Text="Segundo Apellido" AssociatedControlID="txtApellido2" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCCC" Text="CCC" AssociatedControlID="txtIban"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblccdTarifaAutonomos" Text="Tarifa" AssociatedControlID="ccdTarifaAutonomos" CssClass="lblEtiquetas"></rfn:RFNLabel> ',
     '<rfn:RFNLabel runat="server" ID="lblccdTarifaBolsaHoras" Text="Tarifa" AssociatedControlID="ccdTarifaBolsaHoras" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblccdTarifaModalidad" Text="Tarifa" AssociatedControlID="ccdTarifaModalidad" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblccdTarifaProductos" Text="Tarifa" AssociatedControlID="ccdTarifaProductos" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCentros" Text="Datos Centro de Trabajo" ></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCodAnexo" Text="Anexo" AssociatedControlID="txtCodAnexo" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCodContrato" Text="Cod. Contrato" AssociatedControlID="txtCodContrato" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrCodContratoFirma" Text="Cod. Contrato" AssociatedControlID="txtCtrCodContratoFirma" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrCodPresupuestoFirma" Text="Cod. Presupuesto" AssociatedControlID="txtCtrCodPresupuestoFirma" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrColaborador" Text="Colaborador" AssociatedControlID="ccdCtrColaborador" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrEstadoContratoFirma" Text="Estado Contrato" AssociatedControlID="ddlCtrEstadoContratoFirma" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrFecColabDesde" Text="Fecha Desde" AssociatedControlID="calCtrFecColabDesde" CssClass="lblEtiquetas"> </rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrFecFirma" Text="Fecha de Firma" AssociatedControlID="calCtrFecFirma" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrFecPoderDirectivo1" Text="Fecha Poder" AssociatedControlID="calCtrFecPoderDirectivo1" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrFecPoderDirectivo2" Text="Fecha Poder" AssociatedControlID="calCtrFecPoderDirectivo2" CssClass="lblEtiquetas"> </rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrRespRenovacion" Text="Persona QP de Contacto" AssociatedControlID="ccdCtrRespRenovacion" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblCtrtSAP" Text="Contrato SAP" AssociatedControlID="txtCtrtSAP" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblDc" Text="DC" AssociatedControlID="txtIban" CssClass="lblEtiquetasPadd3"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblEmailFilial" Text="Email del cliente" AssociatedControlID="txtEmailFilial" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblFecAnexoRenovacion" Text="Fecha anexo" class="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblFecPoderNotario1" Text="Fecha Poder" AssociatedControlID="calFecPoderNotario1" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblFecPoderNotario2" Text="Fecha Poder" AssociatedControlID="calFecPoderNotario2" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblfiltro2" Text="Código Centro Ventas" AssociatedControlID="txtfiltroCodigo" class="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblfiltro3" Text="Referencia" AssociatedControlID="filtro3" class="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblfiltro4" Text="Código Centro Prestación" AssociatedControlID="txtfiltroCodigo" class="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblIban" Text="IBAN" AssociatedControlID="txtIban" CssClass="lblEtiquetasPadd2"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblIdentificador" Text="CIF" AssociatedControlID="txtIdentificador" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblImpRPF" Text="IMP. Reco.P.F" AssociatedControlID="txtImpRPF" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblImpUndIncl" Text="€/Und Incl." AssociatedControlID="txtImpUndIncl" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lbllineaproducto" Text="Linea Producto" AssociatedControlID="ddllineaproducto" class="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblNIncluidos" Text="Nº Incluidos" AssociatedControlID="txtNIncluidos" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblNomBanco" Text="Banco" AssociatedControlID="txtNomBanco" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblNombre" Text="Nombre" AssociatedControlID="txtNombre" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblNombreCompleto" Text="Razón Social" AssociatedControlID="txtNombre" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblNumCuenta" Text="Cuenta" AssociatedControlID="txtNumCuenta" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblPersonaFilial" Text="Contacto del cliente" AssociatedControlID="txtPersonaFilial" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblRazonSocialAnexoRenovacion" Text="Razón Social" AssociatedControlID="txtCodRazonSocialAnexoRenovacion" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblTelefonoFilial" Text="Teléfono del cliente" AssociatedControlID="txtTelefonoFilial" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblTipDocu" Text="Tipo" AssociatedControlID="rblColInd" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblTipoAnaliticaCompuesta" Text="Analitica" AssociatedControlID="ccdTipoAnaliticaCompuesta" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblTipoAnaliticaPerfil" Text="Perfil" AssociatedControlID="ccdTipoAnaliticaPerfil" CssClass="lblEtiquetas"></rfn:RFNLabel>',
     '<rfn:RFNLabel runat="server" ID="lblTipoAnaliticaSimple" Text="Analitica" AssociatedControlID="ccdTipoAnaliticaSimple" CssClass="lblEtiquetas"></rfn:RFNLabel>'
]

converted_labels = convert_rfn_to_label(rfn_list)

results = []

index = 1

for old_label, new_label in zip(rfn_list, converted_labels):
     results.append(f"Antes {index}: {old_label}")
     results.append(f"Ahora {index}: {new_label}")
     results.append("")
     index = index + 1

with open("resultados.txt", "w", encoding="utf-8") as file:
     file.write("\n".join(results))
    
subprocess.run(["notepad", "resultados.txt"])

print(f"{index - 1} registros cambiados")