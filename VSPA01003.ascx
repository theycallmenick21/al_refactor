<%@ Control Language="VB" AutoEventWireup="false" Inherits="Contratacion.Contrato.Web.Paginas_VSPA01003"
    CodeBehind="VSPA01003.ascx.vb" %>
<%@ Register Assembly="Arq.ControlesWeb" Namespace="Arq.ControlesWeb"
    TagPrefix="rfn" %>
<%@ Import Namespace="Arq.Core.Negocio" %>
<script type="text/javascript" src="../recursos/scripts/VSPA010003.js?<%=ConfArq.Instance.VersionAplicacion%>"></script>
<script type="text/javascript" src="../recursos/scripts/jquery.metadata.js"></script>
<script type="text/javascript">

    Sys.Application.add_load(function () {

        tlbCtrBarraPrincipal = $get('<%=tlbCtrBarraPrincipal.ClientID%>');
        vsCtrContrato = $get('<%=vsCtrContrato.ClientID%>');
        vsErroresCentro = $get('<%=vsErroresCentro.ClientID%>');

        divOcultargrupoCentrosTrabajo = $get('<%=divOcultargrupoCentrosTrabajo.ClientID%>');
        divOcultarapModalidades = $get('<%=divOcultarapModalidades.ClientID%>');
        divOcultarapProductos = $get('<%=divOcultarapProductos.ClientID%>');
        divOcultarapAutonomos = $get('<%=divOcultarapAutonomos.ClientID%>');
        divOcultarapBolsaHoras = $get('<%=divOcultarapBolsaHoras.ClientID%>');

        divOcultargrupoFacturacionPerfiles = $get('<%= divOcultargrupoFacturacionPerfiles.ClientID%>');
        divOcultargrupoFacturacionSimples = $get('<%= divOcultargrupoFacturacionSimples.ClientID%>');
        divOcultargrupoFacturacionCompuestas = $get('<%=  divOcultargrupoFacturacionCompuestas.ClientID%>');

        btnGeneraDocumento = $get('<%=btnGeneraDocumento.ClientID%>');
        lblGenerarDocumentacion = $get('<%=lblGenerarDocumentacion.ClientID%>');

        btnSubeDocumento = $get('<%=btnSubeDocumento.ClientID%>');

        btnreload = $get('<%=btnreload.ClientID%>');
        btnGeneraCargoCuenta = $get('<%=btnGeneraCargoCuenta.ClientID%>');
        btnGenerarCartaBaja = $get('<%=btnGenerarCartaBaja.ClientID%>');
        btnGenerarCartaBaja2 = $get('<%=btnGenerarCartaBaja2.ClientID%>');
        btnGenerarCartaBaja3 = $get('<%=btnGenerarCartaBaja3.ClientID%>');
        btneliminarIPC = $get('<%=btneliminarIPC.ClientID%>');
        btneliminarIPCpartefija = $get('<%=btneliminarIPCpartefija.ClientID%>');
        btnTerminadoToVigente = $get('<%=btnTerminadoToVigente.ClientID%>');
        TerminadoVigente = $get('<%=TerminadoVigente.ClientID%>');
        btnmodificacentro = $get('<%=btnmodificacentro.ClientID%>');

        btnDescargarExcelAux = $get('<%= btnDescargarExcelAux.ClientID%>');

        btnmiracuenta = $get('<%=btnmiracuenta.ClientID%>');

        btnValFace = $get('<%=btnValFace.ClientID%>');

        Cambiobserv = $get('<%=Cambiobserv.ClientID%>');


        btnVerObervaciones = $get('<%=btnVerObervaciones.ClientID%>');
        btnVerActividades = $get('<%=btnVerActividades.ClientID%>');

        txtCtrObserv = $get('<%=txtCtrObserv.ClientID%>');
        ddlobser = $get('<%=ddlobser.ClientID%>');

        hffactparti = $get('<%=hffactparti.ClientID%>');

        hfpermisoBajaFilial = $get('<%=hfpermisoBajaFilial.ClientID%>');
        hfpermisoColab = $get('<%=hfpermisoColab.ClientID%>');
        hfpermisoFecFirma = $get('<%=hfpermisoFecFirma.ClientID%>');
        hfpermisoDireCentro = $get('<%=hfpermisoDireCentro.ClientID%>');
        hfGrabar = $get('<%=hfGrabar.ClientID%>');

        btnMuestraDocumentoCargoCuenta = $get('<%=btnMuestraDocumentoCargoCuenta.ClientID%>');

        grupoCentrosTrabajo = $get('<%=grupoCentrosTrabajo.ClientID%>');

        lblCrearAnexo = $get('<%=lblCrearAnexo.ClientID%>');
        crearAnexo = $get('<%=lblCrearAnexo.ClientID%>');

        lblCrearAnexo = $get('<%=lblCrearAnexoAnalitica.ClientID%>');
        crearAnexoAnaliticas = $get('<%=lblCrearAnexoAnalitica.ClientID%>');

        lblCrearAnexo = $get('<%=lblCrearAnexoRenovacion.ClientID%>');
        crearAnexoRenovacion = $get('<%=lblCrearAnexoRenovacion.ClientID%>');

        lblCrearAnexoAAEE = $get('<%=lblCrearAnexoAAEE.ClientID%>');
        crearAnexoAAEE = $get('<%=crearAnexoAAEE.ClientID%>');

        ccdPrimerRepresentante = $find('<%=ccdPrimerRepresentante.ClientID%>');
        ccdSegundoRepresentante = $find('<%=ccdSegundoRepresentante.ClientID%>');

        chkFormBonif = $find('<%=chkFormBonif.ClientID%>');

        txtRefFact = $find('<%=txtRefFact.ClientID%>');

        ccdRazonSocial = $find('<%=ccdRazonSocial.ClientID%>');
        ccdRazonSocial1 = $find('<%=ccdRazonSocial1.ClientID%>');
        ccdActividad = $find('<%=ccdActividad.ClientID%>');
        chkCaptacionAAEE = $get('<%=chkCaptacionAAEE.ClientID%>');
        chkAutonomo = $find('<%=chkAutonomo.ClientID%>');
        chkAAPP = $find('<%=chkAAPP.ClientID%>');
        ccdGrupoCliente = $find('<%=ccdGrupoCliente.ClientID%>');
        txtCeco = $find('<%=txtCeco.ClientID%>');
        txtLineaNegocio = $find('<%=txtLineaNegocio.ClientID%>');
        txtGestor = $find('<%=txtGestor.ClientID%>');
        cmbProvinciaDS = $find('<%=cmbProvinciaDS.ClientID%>');
        ccdPoblacionDS = $find('<%=ccdPoblacionDS.ClientID%>');
        txtCPDS = $find('<%=txtCPDS.ClientID%>');
        cmbTipoViaDS = $find('<%=cmbTipoViaDS.ClientID%>');
        txtCalleDS = $find('<%=txtCalleDS.ClientID%>');
        txtNumDS = $find('<%=txtNumDS.ClientID%>');
        txtPortalDS = $find('<%=txtPortalDS.ClientID%>');
        txtEscaleraDS = $find('<%=txtEscaleraDS.ClientID%>');
        txtPisoDS = $find('<%=txtPisoDS.ClientID%>');
        txtPuertaDS = $find('<%=txtPuertaDS.ClientID%>');
        txtTelefonoDS = $find('<%=txtTelefonoDS.ClientID%>');
        txtNumFaxDS = $find('<%=txtNumFaxDS.ClientID%>');
        txtEmailDS = $find('<%=txtEmailDS.ClientID%>');
        txtControlCaracteresConCalleDS = $find('<%=txtControlCaracteresConCalleDS.ClientID%>');
        txtControlCaracteresDS = $find('<%=txtControlCaracteresDS.ClientID%>');
        txtControlCaracteresConCalleEnvFact = $find('<%=txtControlCaracteresConCalleEnvFact.ClientID%>');
        txtControlCaracteresEnvFact = $find('<%=txtControlCaracteresEnvFact.ClientID%>');
        checkFactparti = $find('<%=rfncheckFactparti.ClientID%>');

        txtTrabOficina = $find('<%=txtTrabOficina.ClientID%>');
        txtTrabIndustria = $find('<%=txtTrabIndustria.ClientID%>');
        txtTrabConstruccion = $find('<%=txtTrabConstruccion.ClientID%>');
        txtTrabAnexo = $find('<%=txtTrabAnexo.ClientID%>');
        txtTrabTotal = $find('<%=txtTrabTotal.ClientID%>');

        PanelPopDomicilio = $get('<%=PanelPopDomicilio.ClientID%>');

        txtReferenciaDomi = $find('<%=txtReferenciaDomi.ClientID%>');
        cmbProvincia = $find('<%=cmbProvincia.ClientID%>');
        ccdPoblacion = $find('<%=ccdPoblacion.ClientID%>');
        cmbCodPostal = $find('<%=cmbCodPostal.ClientID%>');
        cmbTipoVia = $find('<%=cmbTipoVia.ClientID%>');
        txtCalle = $find('<%=txtCalle.ClientID%>');
        txtNum = $find('<%=txtNum.ClientID%>');
        txtPortal = $find('<%=txtPortal.ClientID%>');
        txtEscalera = $find('<%=txtEscalera.ClientID%>');
        txtPiso = $find('<%=txtPiso.ClientID%>');
        txtPuerta = $find('<%=txtPuerta.ClientID%>');
        txtTelefono = $find('<%=txtTelefono.ClientID%>');
        txtFax = $find('<%=txtFax.ClientID%>');
        chkPrimerCentro = $find('<%=chkPrimerCentro.ClientID%>');
        ccdActividadCentro = $find('<%=ccdActividadCentro.ClientID%>');

        btnGrabarCentro = $get('<%=btnGrabarCentro.ClientID%>');


        btnMigrarDatosContrato = $get('<%=btnMigrarDatosContrato.ClientID%>');

        gvCentrosTrabajo = $find('<%=gvCentrosTrabajo.ClientID%>');
        gvAnaliticasPerfiles = $find('<%=gvAnaliticasPerfiles.ClientID%>');
        gvAnaliticasCompuesta = $find('<%=gvAnaliticasCompuesta.ClientID%>');
        gvAnaliticasSimple = $find('<%=gvAnaliticasSimple.ClientID%>');

        gvCursosFormacion = $find('<%=gvCursosFormacion.ClientID%>');

        gvAnexos = $find('<%=gvAnexos.ClientID%>');

        gvContactos = $find('<%=gvContactos.ClientID%>');

        ccdTipoAnaliticaPerfil = $find('<%=ccdTipoAnaliticaPerfil.ClientID%>');
        btnInsertaAnaliticaPerfil = $find('<%=btnInsertaAnaliticaPerfil.ClientID%>');
        ccdTipoAnaliticaCompuesta = $find('<%=ccdTipoAnaliticaCompuesta.ClientID%>');
        btnInsertaAnaliticaCompuesta = $find('<%=btnInsertaAnaliticaCompuesta.ClientID%>');
        ccdTipoAnaliticaSimple = $find('<%=ccdTipoAnaliticaSimple.ClientID%>');
        btnInsertaAnaliticaSimple = $find('<%=btnInsertaAnaliticaSimple.ClientID%>');

        chkFcomi = $find('<%=chkFcomi.ClientID%>');
        chkRetPdfF = $find('<%=chkRetPdfF.ClientID%>');
        chkRetPdfV = $find('<%=chkRetPdfV.ClientID%>');
        chkModST = $find('<%=chkModST.ClientID%>');
        txtModST = $find('<%=txtModST.ClientID%>');
        chkModHI = $find('<%=chkModHI.ClientID%>');
        txtModHI = $find('<%=txtModHI.ClientID%>');
        chkModEP = $find('<%=chkModEP.ClientID%>');
        txtModEP = $find('<%=txtModEP.ClientID%>');
        chkModMT = $find('<%=chkModMT.ClientID%>');
        txtModMT = $find('<%=txtModMT.ClientID%>');
        txtModTot = $find('<%=txtModTot.ClientID%>');
        txtDescTec = $find('<%=txtDescTec.ClientID%>');
        txtDescTecHoras = $find('<%=txtDescTecHoras.ClientID%>');
        txtDescMed = $find('<%=txtDescMed.ClientID%>');
        txtMotivoDescuento = $find('<%=txtMotivoDescuento.ClientID%>');
        chkAplicaIPC = $find('<%=chkAplicaIPC.ClientID%>');
        chkRecordatorioIPC = $find('<%=chkRecordatorioIPC.ClientID%>');
        calFecDesdeIPC = $find('<%=calFecDesdeIPC.ClientID%>');

        chkModSTCtrt = $find('<%=chkModSTCtrt.ClientID%>');
        txtModSTCtrt = $find('<%=txtModSTCtrt.ClientID%>');
        chkModHICtrt = $find('<%=chkModHICtrt.ClientID%>');
        txtModHICtrt = $find('<%=txtModHICtrt.ClientID%>');
        chkModEPCtrt = $find('<%=chkModEPCtrt.ClientID%>');
        txtModEPCtrt = $find('<%=txtModEPCtrt.ClientID%>');
        chkModMTCtrt = $find('<%=chkModMTCtrt.ClientID%>');
        txtModMTCtrt = $find('<%=txtModMTCtrt.ClientID%>');
        txtModSheCtrt = $find('<%=txtModSheCtrt.ClientID%>');
        txtModTotCtrt = $find('<%=txtModTotCtrt.ClientID%>');
        txtModTotAnx = $find('<%=txtModTotAnx.ClientID%>');
        txtModSTAnx = $find('<%=txtModSTAnx.ClientID%>');
        txtModHIAnx = $find('<%=txtModHIAnx.ClientID%>');
        txtModEPAnx = $find('<%=txtModEPAnx.ClientID%>');
        txtModSheAnx = $find('<%=txtModSheAnx.ClientID%>');
        txtModMTAnx = $find('<%=txtModMTAnx.ClientID%>');
        txtCodContrato = $find('<%=txtCodContrato.ClientID%>');
        txtCtrtSAP = $find('<%=txtCtrtSAP.ClientID%>');
        txtCodRazonSocialAnexoRenovacion = $find('<%=txtCodRazonSocialAnexoRenovacion.ClientID%>');
        txtDesRazonSocialAnexoRenovacion = $find('<%=txtDesRazonSocialAnexoRenovacion.ClientID%>');
        txtCodAnexo = $find('<%=txtCodAnexo.ClientID%>');
        calFechaAnexoRenovacion = $find('<%=calFechaAnexoRenovacion.ClientID%>');
        txtRBPCtrt = $find('<%=txtRBPCtrt.ClientID%>');
        txtRAPCtrt = $find('<%=txtRAPCtrt.ClientID%>');
        txtModRPFCtrt = $find('<%=txtModRPFCtrt.ClientID%>');
        txtRPFIncluidosCtrt = $find('<%=txtRPFIncluidosCtrt.ClientID%>');
        txtRAPAnexo = $find('<%=txtRAPAnexo.ClientID%>');
        txtRBPAnexo = $find('<%=txtRBPAnexo.ClientID%>');
        txtRPFIncluidosAnexo = $find('<%=txtRPFIncluidosAnexo.ClientID%>');
        txtModRPFAnexo = $find('<%=txtModRPFAnexo.ClientID%>');
        chkIPCAnaliticas = $find('<%=chkIPCAnaliticas.ClientID%>');
        txtHDCtrt = $find('<%=txtHDCtrt.ClientID%>');
        txtHDAnx = $find('<%=txtHDAnx.ClientID%>');
        txthd = $find('<%=txthd.ClientID%>');

        calCtrFecGeneracion = $find('<%=calCtrFecGeneracion.ClientID%>');

        calFecTerminado = $find('<%=calFecTerminado.ClientID%>');

        txtModSTDescuento = $find('<%=txtModSTDescuento.ClientID%>');
        txtModHIDescuento = $find('<%=txtModHIDescuento.ClientID%>');
        txtModEPDescuento = $find('<%=txtModEPDescuento.ClientID%>');
        txtModMTDescuento = $find('<%=txtModMTDescuento.ClientID%>');
        txtModTotDescuento = $find('<%=txtModTotDescuento.ClientID%>');
        txtModHorTecDescuento = $find('<%=txtModHorTecDescuento.ClientID%>');
        txtModHorMedDescuento = $find('<%=txtModHorMedDescuento.ClientID%>');
        txtModHorTec = $find('<%=txtModHorTec.ClientID%>');
        txtModHorMed = $find('<%=txtModHorMed.ClientID%>');

        chkfactRecos = $find('<%=chkfactRecos.ClientID%>');
        chkFactAnal = $find('<%=chkFactAnal.ClientID%>');
        chkFactUniVsi = $find('<%=chkFactUniVsi.ClientID%>');
        chkCancenlacionUM = $find('<%=chkCancenlacionUM.ClientID%>');

        txtBajaPeligrosidad = $find('<%=txtBajaPeligrosidad.ClientID%>');
        txtAntBajaPeligrosidad = $find('<%=txtAntBajaPeligrosidad.ClientID%>');
        txtAltaPeligrosidad = $find('<%=txtAltaPeligrosidad.ClientID%>');
        txtAntAltaPeligrosidad = $find('<%=txtAntAltaPeligrosidad.ClientID%>');
        txtIncluyeRecos = $find('<%=txtIncluyeRecos.ClientID%>');
        txtAntIncluyeRecos = $find('<%=txtAntIncluyeRecos.ClientID%>');
        txtDescRecoBaja = $find('<%=txtDescRecoBaja.ClientID%>');
        txtDescRecoAlta = $find('<%=txtDescRecoAlta.ClientID%>');

        txtImpPruebasVSI = $find('<%=txtImpPruebasVSI.ClientID%>');
        txtNIncluidos = $find('<%=txtNIncluidos.ClientID%>');
        txtImpRPF = $find('<%=txtImpRPF.ClientID%>');
        txtImpUndIncl = $find('<%=txtImpUndIncl.ClientID%>');
        txtTarifaAR = $find('<%=txtTarifaAR.ClientID%>');
        txtTarifaBR = $find('<%=txtTarifaBR.ClientID%>');


        chkModRPF = $find('<%=chkModRPF.ClientID%>');
        txtModRPF = $find('<%=txtModRPF.ClientID%>');

        ddlEstadoPresupuesto = $find('<%=ddlEstadoPresupuesto.ClientID%>');
        ddlEstadoPresupuestoOculto = $find('<%=ddlEstadoPresupuestoOculto.ClientID%>');
        calFecEstadoPresupuesto = $find('<%=calFecEstadoPresupuesto.ClientID%>');
        calFecEstadoPresupuestoOculto = $find('<%=calFecEstadoPresupuestoOculto.ClientID%>');
        chkFactVacu = $find('<%=chkFactVacu.ClientID%>');

        chkCtrBajaFutura = $find('<%=chkCtrBajaFutura.ClientID%>');
        calCtrFecBaja = $find('<%=calCtrFecBaja.ClientID%>');
        ddlCtrCausaBaja = $find('<%=ddlCtrCausaBaja.ClientID%>');
        txtCtrObservBaja = $find('<%=txtCtrObservBaja.ClientID%>');
        txtCtrBajaMultiple = $find('<%=txtCtrBajaMultiple.ClientID%>');

        btnBajaMultiple = $get('<%=btnBajaMultiple.ClientID%>');

        ccdCtrColaborador = $find('<%=ccdCtrColaborador.ClientID%>');
        calCtrFecColabDesde = $find('<%=calCtrFecColabDesde.ClientID%>');
        txtCtrPorcentajeColab = $find('<%=txtCtrPorcentajeColab.ClientID%>');
        txtCtrTrimestreColab_1 = $find('<%=txtCtrTrimestreColab_1.ClientID%>');
        txtCtrTrimestreColab_2 = $find('<%=txtCtrTrimestreColab_2.ClientID%>');
        calCtrFecFirma = $find('<%=calCtrFecFirma.ClientID%>');
        calCtrFecFirma1 = $find('<%=calCtrFecFirma1.ClientID%>');
        txtCtrCodContratoFirma = $find('<%=txtCtrCodContratoFirma.ClientID%>');
        ddlCtrEstadoContratoFirma = $find('<%=ddlCtrEstadoContratoFirma.ClientID%>');
        txtCtrCodPresupuestoFirma = $find('<%=txtCtrCodPresupuestoFirma.ClientID%>');
        txtCtrApellido1Representante1 = $find('<%=txtCtrApellido1Representante1.ClientID%>');
        txtCtrApellido2Representante1 = $find('<%=txtCtrApellido2Representante1.ClientID%>');
        txtCtrNombreRepresentante1 = $find('<%=txtCtrNombreRepresentante1.ClientID%>');
        txtCtrIdentificadorRepresentante1 = $find('<%=txtCtrIdentificadorRepresentante1.ClientID%>');
        txtCtrCargoRepresentante1 = $find('<%=txtCtrCargoRepresentante1.ClientID%>');
        txtCtrEmailRepresentante1 = $find('<%=txtCtrEmailRepresentante1.ClientID%>');
        txtCtrApellido1Representante2 = $find('<%=txtCtrApellido1Representante2.ClientID%>');
        txtCtrApellido2Representante2 = $find('<%=txtCtrApellido2Representante2.ClientID%>');
        txtCtrNombreRepresentante2 = $find('<%=txtCtrNombreRepresentante2.ClientID%>');
        txtCtrIdentificadorRepresentante2 = $find('<%=txtCtrIdentificadorRepresentante2.ClientID%>');
        txtCtrCargoRepresentante2 = $find('<%=txtCtrCargoRepresentante2.ClientID%>');
        txtCtrEmailRepresentante2 = $find('<%=txtCtrEmailRepresentante2.ClientID%>');
        txtCtrApellido1Notario1 = $find('<%=txtCtrApellido1Notario1.ClientID%>');
        txtCtrApellido2Notario1 = $find('<%=txtCtrApellido2Notario1.ClientID%>');
        txtCtrNombreNotario1 = $find('<%=txtCtrNombreNotario1.ClientID%>');
        ccdCtrPoblacionNotario1 = $find('<%=ccdCtrPoblacionNotario1.ClientID%>');
        txtCtrProtocoloNotario1 = $find('<%=txtCtrProtocoloNotario1.ClientID%>');
        txtCtrApellido1Notario2 = $find('<%=txtCtrApellido1Notario2.ClientID%>');
        txtCtrApellido2Notario2 = $find('<%=txtCtrApellido2Notario2.ClientID%>');
        txtCtrNombreNotario2 = $find('<%=txtCtrNombreNotario2.ClientID%>');
        ccdCtrPoblacionNotario2 = $find('<%=ccdCtrPoblacionNotario2.ClientID%>');
        txtCtrProtocoloNotario2 = $find('<%=txtCtrProtocoloNotario2.ClientID%>');
        ccdCtrDirectivo1 = $find('<%=ccdCtrDirectivo1.ClientID%>');
        txtCtrCargoDirectivo1 = $find('<%=txtCtrCargoDirectivo1.ClientID%>');
        txtCtrPoderDirectivo1 = $find('<%=txtCtrPoderDirectivo1.ClientID%>');
        calCtrFecPoderDirectivo1 = $find('<%=calCtrFecPoderDirectivo1.ClientID%>');
        ccdCtrDirectivo2 = $find('<%=ccdCtrDirectivo2.ClientID%>');
        txtCtrCargoDirectivo2 = $find('<%=txtCtrCargoDirectivo2.ClientID%>');
        txtCtrPoderDirectivo2 = $find('<%=txtCtrPoderDirectivo2.ClientID%>');
        calCtrFecPoderDirectivo2 = $find('<%=calCtrFecPoderDirectivo2.ClientID%>');
        btnCtrEliminaRepresentante = $get('<%=btnCtrEliminaRepresentante.ClientID%>');
        btnCtrInsertaRepresentante = $get('<%=btnCtrInsertaRepresentante.ClientID%>');
        btnCtrEliminaDirectivo = $get('<%=btnCtrEliminaDirectivo.ClientID%>');
        btnCtrInsertaDirectivo = $get('<%=btnCtrInsertaDirectivo.ClientID%>');
        calCtrFecEstadoContrato = $find('<%=calCtrFecEstadoContrato.ClientID%>');
        calCtrFecEstadoContratoOculto = $find('<%=calCtrFecEstadoContratoOculto.ClientID%>');
        ddlEstadoPresupuesto = $find('<%=ddlEstadoPresupuesto.ClientID%>');
        ddlEstadoPresupuestoOculto = $find('<%=ddlEstadoPresupuestoOculto.ClientID%>');
        calFecEstadoPresupuesto = $find('<%=calFecEstadoPresupuesto.ClientID%>');
        calFecEstadoPresupuestoOculto = $find('<%=calFecEstadoPresupuestoOculto.ClientID%>');

        chkTextoNotario1 = $find('<%=chkTextoNotario1.ClientID%>');
        chkTextoNotario2 = $find('<%=chkTextoNotario2.ClientID%>');
        txtTextoNotario1 = $find('<%=txtTextoNotario1.ClientID%>');
        txtTextoNotario2 = $find('<%=txtTextoNotario2.ClientID%>');
        cmbProvinciaNotario1 = $find('<%=cmbProvinciaNotario1.ClientID%>');
        cmbProvinciaNotario2 = $find('<%=cmbProvinciaNotario2.ClientID%>');
        calFecPoderNotario1 = $find('<%=calFecPoderNotario1.ClientID%>');
        calFecPoderNotario2 = $find('<%=calFecPoderNotario2.ClientID%>');

        chkProductoEspecialMedicina = $find('<%=chkProductoEspecialMedicina.ClientID%>');

        txtCtrCodContrato = $find('<%=txtCtrCodContrato.ClientID%>');
        hfBusqContratoSAP = $get('<%=hfBusqContratoSAP.ClientID%>');
        DesActAnexo = $get('<%=DesActAnexo.ClientID%>');
        txtCtrIdContrato = $find('<%=txtCtrIdContrato.ClientID%>');
        txtCodContratoAsociado = $find('<%=txtCodContratoAsociado.ClientID%>');
        RFNchkRenovable = $find('<%=RFNchkRenovable.ClientID%>');

        txtIdPresupuesto = $find('<%=txtIdPresupuesto.ClientID%>');
        txtCtrCodPresupuesto = $find('<%=txtCtrCodPresupuesto.ClientID%>');

        ddlCtrEstadoContrato = $find('<%=ddlCtrEstadoContrato.ClientID%>');
        ddlCtrEstadoContratoOculto = $find('<%=ddlCtrEstadoContratoOculto.ClientID%>');

        hfHabilitaDatosSociales = $get('<%=hfHabilitaDatosSociales.ClientID%>');
        hfContratoMigrado = $get('<%=hfContratoMigrado.ClientID%>');
        hfNomLogin = $get('<%=hfNomLogin.ClientID%>');
        hfCodPersona = $get('<%=hfCodPersona.ClientID%>');
        hfCodEMPPRL = $get('<%=hfCodEMPPRL.ClientID%>');
        hfCodCentGest = $get('<%=hfCodCentGest.ClientID%>');
        hfidCliente = $get('<%=hfidCliente.ClientID%>');
        hfIdTarifa = $get('<%=hfIdTarifa.ClientID%>');
        hfCodTarifa = $get('<%=hfCodTarifa.ClientID%>');
        hfidIdioma = $get('<%=hfidIdioma.ClientID%>');
        hfIdCentroDireccion = $get('<%=hfIdCentroDireccion.ClientID%>');
        hfIdCentroDireccionP = $get('<%=hfIdCentroDireccionP.ClientID%>');
        hfIdCentroHist = $get('<%=hfIdCentroHist.ClientID%>');
        hfEstadoActualContrato = $get('<%=hfEstadoActualContrato.ClientID%>');
        hfProductoEspecialMedicina = $get('<%=hfProductoEspecialMedicina.ClientID%>');
        hfGestionDirecta = $get('<%=hfGestionDirecta.ClientID%>');
        hfANEXANAL = $get('<%=hfANEXANAL.ClientID%>');
        hfANEXRENO = $get('<%=hfANEXRENO.ClientID%>');
        hfRecosTramo = $get('<%=hfRecosTramo.ClientID%>');
        hfCodUltimoAnexoContrato = $get('<%=hfCodUltimoAnexoContrato.ClientID%>');
        hfFecUltimoAnexoContrato = $get('<%=hfFecUltimoAnexoContrato.ClientID%>');
        hfImpSTAnexoRenovacion = $get('<%=hfImpSTAnexoRenovacion.ClientID%>');
        hfImpHIAnexoRenovacion = $get('<%=hfImpHIAnexoRenovacion.ClientID%>');
        hfImpEPAnexoRenovacion = $get('<%=hfImpEPAnexoRenovacion.ClientID%>');
        hfImpMTAnexoRenovacion = $get('<%=hfImpMTAnexoRenovacion.ClientID%>');
        hfImpRBPAnexoRenovacion = $get('<%=hfImpRBPAnexoRenovacion.ClientID%>');
        hfImpRAPAnexoRenovacion = $get('<%=hfImpRAPAnexoRenovacion.ClientID%>');
        hfImpRPFAnexoRenovacion = $get('<%=hfImpRPFAnexoRenovacion.ClientID%>');
        hfNRPFAnexoRenovacion = $get('<%=hfNRPFAnexoRenovacion.ClientID%>');
        hfImpHDAnexoRenovacion = $get('<%=hfImpHDAnexoRenovacion.ClientID%>');
        hiddenNombreCompleto = $get('<%=hiddenNombreCompleto.ClientID%>');
        hfCpCentro = $get('<%=hfCpCentro.ClientID%>');
        hfFecAlta = $get('<%=hfFecAlta.ClientID%>');
        hfIdDocumentoVisualizacionContrato = $get('<%=hfIdDocumentoVisualizacionContrato.ClientID%>');
        hfProvinciasEspecialesFirmantes = $get('<%=hfProvinciasEspecialesFirmantes.ClientID%>');
        hfIdDomiSocial = $get('<%=hfIdDomiSocial.ClientID%>');
        hfIdDomiEnvio = $get('<%=hfIdDomiEnvio.ClientID%>');

        hfPrecioFirmantes = $get('<%=hfPrecioFirmantes.ClientID%>');

        hfImporteFirmante1 = $get('<%=hfImporteFirmante1.ClientID%>');
        hfImporteFirmante2 = $get('<%=hfImporteFirmante2.ClientID%>');

        hfCargoFirmante1 = $get('<%=hfCargoFirmante1.ClientID%>');
        hfCargoFirmante2 = $get('<%=hfCargoFirmante2.ClientID%>');

        hfFechaContr = $get('<%=hfFechaContr.ClientID%>');
        hfTelefonoDS = $get('<%=hfTelefonoDS.ClientID%>');
        hfEmailDS = $get('<%=hfEmailDS.ClientID%>');
        hfFaxDS = $get('<%=hfFaxDS.ClientID%>');
        hdnPermisoPerfilTarifa = $get('<%=hdnPermisoPerfilTarifa.ClientID%>');
        hfautonomo = $get('<%=hfautonomo.ClientID%>');

        ccdTarifaModalidad = $find('<%=ccdTarifaModalidad.ClientID%>');
        ccdTarifaProductos = $find('<%=ccdTarifaProductos.ClientID%>');
        ccdTarifaBolsaHoras = $find('<%=ccdTarifaBolsaHoras.ClientID%>');
        ccdTarifaAutonomos = $find('<%=ccdTarifaAutonomos.ClientID%>');

        chkGestionInterna = $find('<%=chkGestionInterna.ClientID%>');
        hfGestionInterna = $get('<%=hfGestionInterna.ClientID%>');
        hfidtarifabayes = $get('<%=hfidtarifabayes.ClientID%>');
        hftarifa = $get('<%=hftarifa.ClientID%>');
        hfAnexotarifa = $get('<%=hfAnexotarifa.ClientID%>');

        ccdCtrRespCaptacion = $find('<%=ccdCtrRespCaptacion.ClientID%>');
        hfCodPersonaComerc = $get('<%=hfCodPersonaComerc.ClientID%>');
        ccdCtrRespRenovacion = $find('<%=ccdCtrRespRenovacion.ClientID%>');

        txtPrecioTotalProducto = $find('<%=txtPrecioTotalProducto.ClientID%>');
        txtHorasMedicoProducto = $find('<%=txtHorasMedicoProducto.ClientID%>');
        txtPrecioMedicoProducto = $find('<%=txtPrecioMedicoProducto.ClientID%>');
        txtHorasTecnicoProducto = $find('<%=txtHorasTecnicoProducto.ClientID%>');
        txtPrecioTecnicoProducto = $find('<%=txtPrecioTecnicoProducto.ClientID%>');

        txtPrecioTotalProductoAutonomo = $find('<%=txtPrecioTotalProductoAutonomo.ClientID%>');
        txtHorasMedicoProductoAutonomo = $find('<%=txtHorasMedicoProductoAutonomo.ClientID%>');
        txtPrecioMedicoProductoAutonomo = $find('<%=txtPrecioMedicoProductoAutonomo.ClientID%>');
        txtHorasTecnicoProductoAutonomo = $find('<%=txtHorasTecnicoProductoAutonomo.ClientID%>');
        txtPrecioTecnicoProductoAutonomo = $find('<%=txtPrecioTecnicoProductoAutonomo.ClientID%>');

        txtPrecioTotalProductoBolsaHoras = $find('<%=txtPrecioTotalProductoBolsaHoras.ClientID%>');
        txtHorasMedicoProductoBolsaHoras = $find('<%=txtHorasMedicoProductoBolsaHoras.ClientID%>');
        txtPrecioMedicoProductoBolsaHoras = $find('<%=txtPrecioMedicoProductoBolsaHoras.ClientID%>');
        txtHorasTecnicoProductoBolsaHoras = $find('<%=txtHorasTecnicoProductoBolsaHoras.ClientID%>');
        txtPrecioTecnicoProductoBolsaHoras = $find('<%=txtPrecioTecnicoProductoBolsaHoras.ClientID%>');

        lblCtrTrimestreColab = $get('<%=lblCtrTrimestreColab.ClientID%>');
        lblDesdeContrato = $get('<%=lblDesdeContrato.ClientID%>');
        lblHistColab = $get('<%=lblHistColab.ClientID%>');

        <%--lblLegendDesdeContrato = $get('<%=lblLegendDesdeContrato.ClientID%>')--%>
        lblLegendHistColab = $get('<%=lblLegendHistColab.ClientID%>');

        cmbListaContratosCliente = $find('<%=cmbListaContratosCliente.ClientID%>');

        ccdCentroGestion = $find('<%=ccdCentroGestion.ClientID%>');
        ccdPersonaAlta = $find('<%=ccdPersonaAlta.ClientID%>');

        gvProducto = $find('<%=gvProducto.ClientID%>');
        gvProductoAutonomo = $find('<%=gvProductoAutonomo.ClientID%>');
        gvProductoBolsaHoras = $find('<%=gvProductoBolsaHoras.ClientID%>');
        gvCtrDatosFicherosDigital = $find('<%=gvCtrDatosFicherosDigital.ClientID%>');

        txtImporteTotalContrato = $find('<%=txtImporteTotalContrato.ClientID%>');
        txtTipoContrato = $find('<%=txtTipoContrato.ClientID%>');

        calIPCDesde = $find('<%=calIPCDesde.ClientID%>');
        calFecIniFact = $find('<%=calFecIniFact.ClientID%>');
        rfncalmigrado = $find('<%=rfncalmigrado.ClientID%>');
        chkFactPorCentro = $find('<%=chkFactPorCentro.ClientID%>');
        //dvv 
        chkFactLibre = $find('<%=chkFactLibre.ClientID%>');
        chkFactLibreF = $find('<%=chkFactLibreF.ClientID%>');
        chkFactLibreV = $find('<%=chkFactLibreV.ClientID%>');

        chkFLrec = $find('<%=chkFLrec.ClientID%>');
        chkFLana = $find('<%=chkFLana.ClientID%>');
        chkFLvsi = $find('<%=chkFLvsi.ClientID%>');

        chkFactElectronica = $find('<%=chkFactElectronica.ClientID%>');

        //dvv fact_u_desgl
        chkFact_U_DESGL = $find('<%=chkFact_U_DESGL.ClientID%>');

        chkFactPeriodoVenc = $find('<%=chkFactPeriodoVenc.ClientID%>');
        chkCarteraNegociada = $find('<%=chkCarteraNegociada.ClientID%>');

        chkFactModCent = $find('<%=chkFactModCent.ClientID%>');
        chkFactActHigCent = $find('<%=chkFactActHigCent.ClientID%>');
        chkFactRecMedCent = $find('<%=chkFactRecMedCent.ClientID%>');
        chkFactAnalCent = $find('<%=chkFactAnalCent.ClientID%>');
        calFecFactModCentDesde = $find('<%=calFecFactModCentDesde.ClientID%>');
        calFecFactActHigCentDesde = $find('<%=calFecFactActHigCentDesde.ClientID%>');
        calFecFactRecMedCentDesde = $find('<%=calFecFactRecMedCentDesde.ClientID%>');
        calFecFactAnalCentDesde = $find('<%=calFecFactAnalCentDesde.ClientID%>');

        chkEnvCentro = $find('<%=chkEnvCentro.ClientID%>');
        chkIndIPC = $find('<%=chkIndIPC.ClientID%>');

        imgDetalleFactCentro = $get('<%=imgDetalleFactCentro.ClientID%>');


        cmbProvinciaEnvFact = $find('<%=cmbProvinciaEnvFact.ClientID%>');
        ccdPoblacionEnvFact = $find('<%=ccdPoblacionEnvFact.ClientID%>');
        cmbCPEnvFact = $find('<%=cmbCPEnvFact.ClientID%>');
        cmbTipoViaEnvFact = $find('<%=cmbTipoViaEnvFact.ClientID%>');
        txtCalleEnvFact = $find('<%=txtCalleEnvFact.ClientID%>');
        txtNumEnvFact = $find('<%=txtNumEnvFact.ClientID%>');
        txtPortalEnvFact = $find('<%=txtPortalEnvFact.ClientID%>');
        txtEscaleraEnvFact = $find('<%=txtEscaleraEnvFact.ClientID%>');
        txtPisoEnvFact = $find('<%=txtPisoEnvFact.ClientID%>');
        txtPuertaEnvFact = $find('<%=txtPuertaEnvFact.ClientID%>');
        txtTelefonoEnvFact = $find('<%=txtTelefonoEnvFact.ClientID%>');
        txtNumFaxEnvFact = $find('<%=txtNumFaxEnvFact.ClientID%>');
        txtEmailEnvFact = $find('<%=txtEmailEnvFact.ClientID%>');
        txtAtencionEnvFact = $find('<%=txtAtencionEnvFact.ClientID%>');

        txtNumPedidoF = $find('<%=txtNumPedidoF.ClientID%>');
        txtNumPedidoV = $find('<%=txtNumPedidoV.ClientID%>');

        calFecUltReno = $find('<%=calFecUltReno.ClientID%>');
        calFecFin = $find('<%=calFecFin.ClientID%>');

        rblTipoPago = $find('<%=rblTipoPago.ClientID%>');
        rblPeriPago = $find('<%=rblPeriPago.ClientID%>');

        imgCierrepopUpCentros = $get('<%=imgCierrepopUpCentros.ClientID%>');
        imgCierrepopUpDesdeContrato = $get('<%=imgCierrepopUpDesdeContrato.ClientID%>');
        imgCierrepopUpHistColab = $get('<%=imgCierrepopUpHistColab.ClientID%>');

        cmbPlazoPago = $find('<%=cmbPlazoPago.ClientID%>');

        txtNombreCompleto = $find('<%=txtNombreCompleto.ClientID%>');
        txtNombre = $find('<%=txtNombre.ClientID%>');
        txtApellido1 = $find('<%=txtApellido1.ClientID%>');
        txtApellido2 = $find('<%=txtApellido2.ClientID%>');
        rblColInd = $find('<%=rblColInd.ClientID%>');
        lblIdentificador = $get('<%=lblIdentificador.ClientID%>');
        txtIdentificador = $find('<%=txtIdentificador.ClientID%>');
        txtNomBanco = $find('<%=txtNomBanco.ClientID%>');
        txtNumCuenta = $find('<%=txtNumCuenta.ClientID%>');
        txtIban = $find('<%=txtIban.ClientID%>');

        chkMigrarContactos = $find('<%=chkMigrarContactos.ClientID%>');
        chkMigrarFirmantesCliente = $find('<%=chkMigrarFirmantesCliente.ClientID%>');
        chkMigrarFirmantesSPFM = $find('<%=chkMigrarFirmantesSPFM.ClientID%>');

        chkGenerarFirmado = $find('<%=chkGenerarFirmado.ClientID%>');
        chkGenerarFirmaOtp = $find('<%=chkGenerarFirmaOtp.ClientID%>');

        txtCtrContratoAntiguo = $find('<%=txtCtrContratoAntiguo.ClientID%>');
        txtCtrContratoNuevo = $find('<%=txtCtrContratoNuevo.ClientID%>');

        txtCtrObservaciones = $find('<%=txtCtrObservaciones.ClientID%>');
        txtCtrVersionDocumento = $find('<%=txtCtrVersionDocumento.ClientID%>');

        btnCtrMostrarVersionDocumento = $find('<%=btnCtrMostrarVersionDocumento.ClientID%>');

        fuDocumento = $find('<%=fuDocumento.ClientID%>');

        rblAltaColIndSocial = $find('<%=rblAltaColIndSocial.ClientID%>');
        txtAltaNombreCompletoSocial = $find('<%=txtAltaNombreCompletoSocial.ClientID%>');
        txtAltaNombreSocial = $find('<%=txtAltaNombreSocial.ClientID%>');
        txtAltaApellido1Social = $find('<%=txtAltaApellido1Social.ClientID%>');
        txtAltaApellido2Social = $find('<%=txtAltaApellido2Social.ClientID%>');
        nombreAltaSocial = $get('<%=nombreAltaClienteSocial.ClientID%>');
        nomIndividualSocial = $get('<%=nomAltaIndividualSocial.ClientID%>');
        ape1IndividualSocial = $get('<%=ape1AltaIndividualSocial.ClientID%>');
        ape2IndividualSocial = $get('<%=ape2AltaIndividualSocial.ClientID%>');
        nomColectivoSocial = $get('<%=nomAltaColectivoSocial.ClientID%>');

        btnGrabaDomiSocial = $get('<%=btnGrabaDomiSocial.ClientID%>');

        chkDatosFACE = $find('<%=chkDatosFACE.ClientID%>');
        txtOrganoGestor = $find('<%=txtOrganoGestor.ClientID%>');
        txtUnidadTramitadora = $find('<%=txtUnidadTramitadora.ClientID%>');
        txtOficinaContable = $find('<%=txtOficinaContable.ClientID%>');
        txtOrganoProponente = $find('<%=txtOrganoProponente.ClientID%>');

        txtdiapago = $find('<%=txtdiapago.ClientID%>');

        chkFact_U_DESGL = $find('<%=chkFact_U_DESGL.ClientID%>');
        hfface = $find('<%=hfface.ClientID%>');
        txtContratoSAP = $find('<%=txtContratoSAP.ClientID%>');

        hfModCuenta = $get('<%=hfModCuenta.ClientID%>');
        hfOtrasVsi = $get('<%=hfOtrasVsi.ClientID%>');
        hfModColab = $get('<%=hfModColab.ClientID%>');

        ccdCifPagador = $find('<%=ccdCifPagador.ClientID%>');
        divActivarCifPagador = $find('<%=divActivarCifPagador.ClientID%>');
        hfGrabar99 = $get('<%=hfGrabar99.ClientID%>');
        divSuspendido = $get('<%=divSuspendido.ClientID%>');

        rdSeres = $find('<%=rdSeres.ClientID%>');
        rdfirmaxml = $find('<%=rdfirmaxml.ClientID%>');
        rfncalInicioSuspendido2 = $find('<%=rfncalInicioSuspendido2.ClientID%>');
        rfncalfinSuspendido = $find('<%=rfncalfinSuspendido.ClientID%>');
        hfActivarAnexoAAEE = $get('<%=hfActivarAnexoAAEE.ClientID%>');
        hfPrecioHoraSHE = $get('<%=hfPrecioHoraSHE.ClientID%>');
        hfDesfaseHorasSHE = $get('<%=hfDesfaseHorasSHE.ClientID%>');
        hfA_FormulaHorasSHE = $get('<%=hfA_FormulaHorasSHE.ClientID%>');
        hfActivarAnexoBH = $get('<%=hfActivarAnexoBH.ClientID%>');
        camposQS = $get('<%=camposQS.ClientID%>');
        rfnchkpedido = $find('<%=rfnchkpedido.ClientID%>');
        rfnchkcerrado = $find('<%=rfnchkcerrado.ClientID%>');

        FcmbProvincia = $find('<%=FcmbProvincia.ClientID%>');
        FccdPoblacion = $find('<%=FccdPoblacion.ClientID%>');

        //envio particularizado
        cmbProvinciaEnvFactP = $find('<%=cmbProvinciaEnvFactP.ClientID%>');
        ccdPoblacionEnvFactP = $find('<%=ccdPoblacionEnvFactP.ClientID%>');
        cmbCPEnvFactP = $find('<%=cmbCPEnvFactP.ClientID%>');
        cmbTipoViaEnvFactP = $find('<%=cmbTipoViaEnvFactP.ClientID%>');
        txtCalleEnvFactP = $find('<%=txtCalleEnvFactP.ClientID%>');
        txtNumEnvFactP = $find('<%=txtNumEnvFactP.ClientID%>');
        txtPortalEnvFactP = $find('<%=txtPortalEnvFactP.ClientID%>');
        txtEscaleraEnvFactP = $find('<%=txtEscaleraEnvFactP.ClientID%>');
        txtPisoEnvFactP = $find('<%=txtPisoEnvFactP.ClientID%>');
        txtPuertaEnvFactP = $find('<%=txtPuertaEnvFactP.ClientID%>');
        txtTelefonoEnvFactP = $find('<%=txtTelefonoEnvFactP.ClientID%>');
        txtNumFaxEnvFactP = $find('<%=txtNumFaxEnvFactP.ClientID%>');
        txtAtencionEnvFactP = $find('<%=txtAtencionEnvFactP.ClientID%>');
        txtEmailEnvFactP = $find('<%=txtEmailEnvFactP.ClientID%>');

        //Filiales
        hdnPresupuestoQS = $get('<%= hdnPresupuestoQS.ClientID %>');
        hdnPresupuestoTebex = $get('<%= hdnPresupuestoTebex.ClientID %>');
        hdnPresupuestoQPPortugal = $get('<%= hdnPresupuestoQPPortugal.ClientID %>');
        hdnPresupuestoMedycsa = $get('<%= hdnPresupuestoMedycsa.ClientID %>');
        hdnPresupuestoQPPeru = $get('<%= hdnPresupuestoQPPeru.ClientID %>');

        txtHorasPerfilesMedycsa = $find('<%= txtHorasPerfilesMedycsa.ClientID %>');

        txtDomicilioFacturacionFilial = $find('<%= txtDomicilioFacturacionFilial.ClientID %>');
        txtProvinciaFilial = $find('<%= txtProvinciaFilial.ClientID %>');
        txtPoblacionFilial = $find('<%= txtPoblacionFilial.ClientID %>');
        txtCPFilial = $find('<%= txtCPFilial.ClientID %>');
        empresaFilial = $find('<%= empresaFilial.ClientID %>');
        nifRazonSocialFilial = $get('<%= nifRazonSocialFilial.ClientID %>');
        nifFilial = $find('<%= nifFilial.ClientID %>');
        txtEmailFilial = $find('<%=txtEmailFilial.ClientID%>');
        txtTelefonoFilial = $find('<%=txtTelefonoFilial.ClientID%>');
        txtPersonaFilial = $find('<%=txtPersonaFilial.ClientID%>');
        lblProvinciaFilial = $get('<%=lblProvinciaFilial.ClientID%>');
        lblPoblacionFilial = $get('<%=lblPoblacionFilial.ClientID%>');
        lblDomicilioFacturacionFilial = $get('<%=lblDomicilioFacturacionFilial.ClientID%>');
        lblCPFilial = $get('<%=lblCPFilial.ClientID%>');

        //no lanzar busqueda de centros
        hfCentContrato = $get('<%=hfCentContrato.ClientID%>');
        hfNumMaxCentros = $get('<%=hfNumMaxCentros.ClientID%>');

        hfCodColaborIESA = $get('<%=hfCodColaborIESA.ClientID%>');
        hfpermisoFactLibre_IESA = $get('<%=hfpermisoFactLibre_IESA.ClientID%>');

        //Tarifa x usuario
        hfpermisoTarifa = $get('<%=hfpermisoTarifa.ClientID%>');
        lblhistTarifa = $get('<%=lblhistTarifa.ClientID%>');
        hfCodTarifaPermitida = $get('<%=hfCodTarifaPermitida.ClientID%>');

        estadoDocumento = $get('<%=estadoDocumento.ClientID%>');
        espacioEstadoDocumento = $get('<%=espacioEstadoDocumento.ClientID%>');
        chkSinCentro = $find('<%=chkSinCentro.ClientID%>');
        seccionCartaBaja = $get('<%=seccionCartaBaja.ClientID%>');

        hfProvinciaSocialContrato = $get('<%=hfProvinciaSocialContrato.ClientID%>');
        hfPoblacionSocialContrato = $get('<%=hfPoblacionSocialContrato.ClientID%>');
    });

</script>
<script type="text/javascript" src="../recursos/scripts/Download.js?<%=ConfArq.Instance.VersionAplicacion%>"></script>

<style type="text/css">
    .ventanaPrincipal {
        padding: 10px 10px 10px 10px;
        width: 1080px;
        display: block;
    }

    .extensorVentana {
        width: 100% !important;
        display: inline !important;
    }

    .seccionPrincipalModalidad {
        margin-top: 10px;
        margin-bottom: 10px;
        display: block;
    }

    .seccionPrincipalModalidad {
        clear: both;
        overflow: hidden;
        display: block;
    }

    .seccionesPrincipales {
        margin-top: 10px;
        margin-bottom: 10px;
        width: 88% !important;
        clear: both;
        overflow: hidden;
        display: block;
    }

    .seccionesPrincipales2 {
        margin-top: 10px;
        margin-bottom: 10px;
        display: block;
        clear: both;
        overflow: hidden;
        width: 87% !important;
    }

    .seccionesPrincipales3 {
        margin-top: 10px;
        margin-bottom: 10px;
        width: 95% !important;
        display: block;
        clear: both;
        overflow: hidden;
    }

    .seccionesPrincipales4 {
        margin-top: 10px;
        margin-left: 10px;
        margin-bottom: 10px;
        width: 80%;
        display: block;
        clear: both;
        overflow: hidden;
    }

    .seccionesPrincipales5 {
        margin-top: 10px;
        margin-bottom: 10px;
        width: 99% !important;
        display: block;
        clear: both;
        overflow: hidden;
    }

    .seccionesPrincipales_prueba {
        margin-top: 10px;
        margin-bottom: 10px;
        margin-right: 0px;
        padding-right: 0px;
        max-width: 1000px;
        width: 98% !important;
        display: block;
        clear: both;
        overflow: hidden;
    }


    .seccionesPrincipalesFieldSetRecos {
        margin-bottom: 10px;
        width: 86% !important;
        display: block;
        margin-left: 10px;
    }

    .seccionesPrincipalesHistColab {
        margin-top: 10px;
        margin-bottom: 10px;
        width: 95% !important;
        display: block;
    }

    .elementosSeccionPrincipalDS {
        float: left;
        margin: 0px 45px 0px 0px;
        min-height: 45px;
        display: block;
    }

    .elementosSeccionPrincipalDS2 {
        float: left;
        margin: 0px 5px 0px 0px;
        min-height: 45px;
        display: block;
    }

    .elementosSeccionPrincipalPadd2 {
        float: left;
        margin: 0px 10px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalPadd {
        float: left;
        margin: 10px 45px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalPadd3 {
        float: left;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalPadd20 {
        float: left;
        margin: 20px 45px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalPadd4 {
        float: left;
        margin: 0px 45px 0px 37px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalGenerar {
        float: left;
        margin: 10px 45px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipal {
        float: left;
        margin: 0px 45px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalMostrarDoc {
        float: left;
        margin: 0px 0px 0px 0px;
        display: block;
    }

    .elementosSeccionPrincipalPop {
        float: left;
        margin: 0px 0px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalCent {
        float: left;
        margin: 0px 0px 0px 0px;
        min-height: 30px;
        display: block;
        width: 400px;
    }

    .elementosSeccionPrincipalCercano {
        float: left;
        margin: 0px 10px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipallejano {
        float: left;
        margin: 0px 350px 0px 0px;
        min-height: 30px;
        display: block;
    }

    .elementosSeccionPrincipalProducto {
        float: left;
        margin: 1px 1px 1px 1px;
        display: block;
    }

    .subelementosSeccionPrincipalPadd {
        clear: both;
        overflow: hidden;
        margin: 0px 0px 10px 0px;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipalPadd2 {
        clear: both;
        overflow: hidden;
        margin: 10px 0px 0px 0px;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipalPadd3 {
        clear: both;
        overflow: hidden;
        margin: 10px 0px 10px 0px;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipalAnexo {
        clear: both;
        overflow: hidden;
        margin: 10px 0px 0px 0px;
        display: block;
    }

    .subelementosSeccionPrincipalPadd8 {
        clear: both;
        overflow: hidden;
        margin: 10px 0px 10px 0px;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipal {
        clear: both;
        overflow: hidden;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipal_prueba {
        clear: both;
        overflow: hidden;
        display: block;
        min-height: 30px;
        max-width: 1000px;
        margin-right: 0px;
    }

    .subelementosSeccionPrincipalMostrarDoc {
        clear: both;
        overflow: hidden;
        display: block;
    }

    .subelementosSeccionPrincipalDesdeContrato {
        clear: both;
        margin: 10px 10px 10px 10px;
        overflow: hidden;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipalHistColab {
        clear: both;
        margin: 10px 10px 10px 10px;
        overflow: hidden;
        display: block;
        min-height: 30px;
    }

    .subelementosSeccionPrincipalGrid {
        clear: both;
        overflow: auto;
        display: block;
        max-height: 300px;
        min-height: 70px;
        max-width: 1100px;
        font-size: 10px;
        width: 98% !important;
    }

    .subelementosSeccionPrincipalGridContactos {
        clear: both;
        overflow: auto;
        display: block;
        max-height: 300px;
        min-height: 70px;
        max-width: 1100px;
        font-size: 10px;
        width: 98% !important;
    }

    .Ejemplo {
        overflow: hidden;
        min-height: 5px;
        width: 1000px;
        max-width: 950px;
    }

    .subelementosSeccionPrincipalPaddProducto {
        clear: both;
        overflow: hidden;
        margin: 1px 1px 1px 1px;
        display: block;
    }

    .elementoDescuento {
        clear: both;
        overflow: hidden;
        margin: 10px 0px 0px 0px;
        display: block;
    }

    .elementosModalidades {
        float: left;
        margin: 0px 15px 0px 0px;
        min-height: 30px;
        min-width: 100px;
        display: block;
    }

    .lblEtiquetas {
        display: block;
    }

    .lblEtiquetaOculta {
        display: block;
        display: none;
    }

    .lblEtiquetaBoton {
        min-height: 20px;
        display: block;
        text-align: center;
        vertical-align: middle;
    }

    .lblEtiquetasPadd {
        display: block;
        margin: 0px 0px 7px 0px;
    }

    .lblEtiquetasPadd2 {
        margin: 0px 8px 0px 0px;
    }

    .lblEtiquetasPadd3 {
        margin: 0px 20px 0px 0px;
    }

    .lblLeyendas legend {
        text-transform: uppercase;
    }

    .control {
        width: 100%;
    }

    .control_ddl {
        width: 500px;
    }

    .control_txt {
        width: 75px;
    }

    .control_txt2 {
        width: 50px;
    }

    .control_izquierda {
        float: left;
        display: block;
        margin: 0px 0px 0px 0px;
    }

    .control_derecha {
        float: right;
        display: block;
        margin: 0px 0px 0px 0px;
    }

    .clear {
        clear: both;
    }

    .columnaInvisible {
        display: none;
    }

    .controlInvisible {
        display: none;
    }

    .popupControl {
        position: absolute;
        background-color: #FFFFFF;
        border-style: solid;
        border-color: Black;
        border-width: 2px;
        width: 555px;
    }

    .popupControlDesdeContrato {
        position: absolute;
        background-color: #FFFFFF;
        border-style: solid;
        border-color: Black;
        border-width: 2px;
        width: 950px;
    }

    .popupControlHistColab {
        position: absolute;
        background-color: #FFFFFF;
        border-style: solid;
        border-color: Black;
        border-width: 2px;
        width: 950px;
    }

    .popupControlAnexoRenovacion {
        position: absolute;
        background-color: #FFFFFF;
        border-style: solid;
        border-color: Black;
        border-width: 2px;
        width: 600px;
    }

    .subelementosSeccionPrincipalPaddMargen {
        overflow: hidden;
        display: block;
    }

    .popupMenu {
        position: absolute;
        visibility: hidden;
        background-color: #F5F7F8;
    }

    .popupHover {
        background: #DDD;
        color: #555;
        border-right: 1px solid #B2B2B2;
        background-position: left top;
    }

    .seccionesFieldSetN5 {
        margin-top: 10px;
        margin-bottom: 10px;
        margin-right: 5px;
        margin-left: 0px;
        display: block;
        width: 950px;
        overflow: hidden;
    }

    .productosGridConScrollHoriz {
        margin: 10px 0px 0px 0px;
        clear: both;
        display: block;
        font-size: 9px;
        max-width: 940px;
        max-height: 8000px;
        overflow-x: scroll;
        overflow-y: hidden;
    }

    .elementoColumnaPadd {
        float: left;
        margin: 10px 5px 5px 5px;
        min-height: 5px;
        display: block;
    }
</style>
<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <table style="border-collapse: collapse; width: 100%;">
            <tr style="border-collapse: collapse; width: 100%;">
                <td style="border-collapse: collapse; width: 100%;">
                    <div id="formulario" class="ventanaPrincipal">
                        <div class="seccionesPrincipales3">
                            <rfn:RFNToolBar ID="tlbCtrBarraPrincipal" runat='server' class="extensorVentana"
                                MostrarBotonGuardar="true" mostrarcancelar="false" MostrarBotonLimpiarForm="false"
                                MostrarBotonBaja="false" MostrarBotonCancelar="false" BotonDefecto="Guardar"
                                MostrarBotonAlta="false" CancelarCausesValidation="false" BajaCausesValidation="false"
                                GuardarCausesValidation="True" ToolTip="true" OnClientClick="MenuCtrClick" GuardarValidationGroup="vGuardaContrato"
                                Titulo="Contrato" Width="100%">
                                <MenuItems>
                                    <asp:MenuItem Text="Gestión de Contactos del Cliente" Value="Contactos"></asp:MenuItem>
                                </MenuItems>
                            </rfn:RFNToolBar>
                            <rfn:RFNValidationSummary ID="vsCtrContrato" runat="server" ShowMessageBox="False"
                                ShowSummary="True" ValidationGroup="vGuardaContrato"></rfn:RFNValidationSummary>
                            <rfn:RFNValidationSummary ID="vsErroresCentro" runat="server" ShowMessageBox="True"
                                ShowSummary="False" ValidationGroup="GuardaCentroTrabajoP" />
                            <rfn:RFNHiddenField ID="DesActAnexo" runat="server" />
                            <rfn:RFNHiddenField ID="hfContratoMigrado" runat="server" />
                            <rfn:RFNHiddenField ID="hfHabilitaDatosSociales" runat="server" Value="N" />
                            <rfn:RFNHiddenField ID="hfface" runat="server" />
                            <rfn:RFNHiddenField ID="hfNomLogin" runat="server" />
                            <rfn:RFNHiddenField ID="hfCodPersona" runat="server" />
                            <rfn:RFNHiddenField ID="hfCodEMPPRL" runat="server" />
                            <rfn:RFNHiddenField ID="hfCodCentGest" runat="server" />
                            <rfn:RFNHiddenField ID="hfidCliente" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfIdTarifa" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfCodTarifa" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfCodTarifaPermitida" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfidIdioma" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfIdCentroDireccion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfIdCentroDireccionP" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfIdCentroHist" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfEstadoActualContrato" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfProductoEspecialMedicina" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfGestionDirecta" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfIdDomiSocial" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfIdDomiEnvio" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfPrecioFirmantes" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImporteFirmante1" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImporteFirmante2" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfCargoFirmante1" runat="server" Value="N" />
                            <rfn:RFNHiddenField ID="hfCargoFirmante2" runat="server" Value="N" />
                            <rfn:RFNHiddenField ID="hfFechaContr" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfGestionInterna" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfIdDocumentoVisualizacion" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfCpCentro" runat="server" />
                            <rfn:RFNHiddenField ID="hdnPermisoPerfilTarifa" runat="server" Value="N" />
                            <rfn:RFNHiddenField ID="hfBusqContratoSAP" runat="server" />
                            <rfn:RFNHiddenField ID="hfidtarifabayes" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfModCuenta" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfModColab" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfANEXANAL" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfANEXRENO" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfRecosTramo" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfCodUltimoAnexoContrato" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfFecUltimoAnexoContrato" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpSTAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpHIAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpEPAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpMTAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpRBPAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpRAPAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpRPFAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfNRPFAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfImpHDAnexoRenovacion" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfOtrasVsi" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hftarifa" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfAnexotarifa" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfGrabar99" runat="server" Value="N" />
                            <rfn:RFNHiddenField ID="hfIdCentro" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfActivarAnexoAAEE" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfActivarAnexoBH" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hdnTieneElPresupProductosPruebasVSI" Value="" runat="server" />
                            <rfn:RFNHiddenField ID="hfCodPersonaComerc" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfPrecioHoraSHE" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfDesfaseHorasSHE" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfA_FormulaHorasSHE" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfautonomo" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hffactparti" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfpermisoColab" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfpermisoBajaFilial" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfpermisoFecFirma" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfpermisoDireCentro" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfGrabar" runat="server" Value="0" />
                            <rfn:RFNHiddenField ID="hfFecAlta" runat="server" Value="" />

                            <rfn:RFNHiddenField ID="hdnPresupuestoQS" runat="server" Value="" />

                            <rfn:RFNHiddenField ID="hiddenNombreCompleto" runat="server" Value="" />

                            <rfn:RFNHiddenField ID="hdnPresupuestoTebex" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hdnPresupuestoQPPortugal" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hdnPresupuestoMedycsa" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hdnPresupuestoQPPeru" runat="server" Value="" />

                            <rfn:RFNHiddenField ID="hfCentContrato" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfNumMaxCentros" runat="server" Value="" />

                            <rfn:RFNHiddenField ID="hfCodColaborIESA" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfpermisoFactLibre_IESA" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfIdDocumentoVisualizacionContrato" runat="server" />
                            <rfn:RFNHiddenField ID="hfpermisoTarifa" runat="server" Value="" />

                            <rfn:RFNHiddenField ID="hfProvinciasEspecialesFirmantes" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfProvinciaSocialContrato" runat="server" Value="" />
                            <rfn:RFNHiddenField ID="hfPoblacionSocialContrato" runat="server" Value="" />

                            <asp:UpdatePanel ID="UpHiddenFields" runat="server">
                                <ContentTemplate>
                                    <rfn:RFNHiddenField ID="hfDCCGenerado" runat="server" />
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <div class="subelementosSeccionPrincipal">
                                <div id="BotonesDocumentacion" class="elementosSeccionPrincipalGenerar" style="display: block">
                                    <div id="generaDocumentacion" class="elementosSeccionPrincipalCercano">
                                        <label id="lblGenerarDocumentacion" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 155px">Generar Documentación</label>
                                        <rfn:RFNCheckBox ID="chkGenerarFirmado" runat="server" Text="Generar Documento Firmado"
                                            OnClientClick="CheckFirmaEscaneada" Enabled="True"></rfn:RFNCheckBox>

                                    </div>
                                    <div id="generaCargoCuenta" class="elementosSeccionPrincipalCercano" style="display: none">
                                        <label id="lblGenerarCargoCuenta" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 155px">Doc. cargo en cuenta</label>
                                    </div>
                                    <div id="eliminarIPC" runat="server" class="elementosSeccionPrincipalCercano" style="display: none">
                                        <label id="lbleliminarIPC" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 100px; pointer-events: none; opacity: 0.6">Eliminar IPC</label>
                                    </div>
                                    <div id="TerminadoVigente" runat="server" class="elementosSeccionPrincipalCercano" style="display: none">
                                        <label id="lblTerminadoToVigente" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 175px; pointer-events: none; opacity: 0.6">Pasar a Vigente</label>
                                    </div>
                                    <div id="eliminarIPC2" runat="server" class="elementosSeccionPrincipalCercano" style="display: none">
                                        <label id="lbleliminarIPC2" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 110px; pointer-events: none; opacity: 0.6">Eliminar IPC Fija</label>
                                    </div>
                                    <div style="display: none">
                                        <rfn:RFNButton ID="btnGeneraDocumento" runat="server" CausesValidation="True" ValidationGroup="vGuardaContrato"></rfn:RFNButton>
                                        <rfn:RFNButton ID="btnGeneraCargoCuenta" runat="server" CausesValidation="True" ValidationGroup="vGuardaContrato" Style="display: none"></rfn:RFNButton>
                                        <rfn:RFNButton ID="btnGenerarCartaBaja" runat="server" CausesValidation="False"></rfn:RFNButton>
                                        <rfn:RFNButton ID="btnGenerarCartaBaja2" runat="server" CausesValidation="False"></rfn:RFNButton>
                                        <rfn:RFNButton ID="btnGenerarCartaBaja3" runat="server" CausesValidation="False"></rfn:RFNButton>
                                        <rfn:RFNButton ID="btnreload" runat="server" CausesValidation="False"></rfn:RFNButton>
                                        <rfn:RFNButton ID="btneliminarIPC" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btneliminarIPCpartefija" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnTerminadoToVigente" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnmodificacentro" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnmiracuenta" runat="server" CausesValidation="False" ScriptEnabled="True" Style="display: none" />
                                        <rfn:RFNButton ID="btnValFace" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnVerObervaciones" runat="server" CausesValidation="False" Style="display: block"
                                            ScriptEnabled="True" UseSubmitBehavior="False" />
                                        <rfn:RFNButton ID="btnDescargarExcelAux" runat="server" Text="Cargar" CausesValidation="False"
                                            Height="15px" Style="display: none"></rfn:RFNButton>

                                        <rfn:RFNButton ID="btnVerActividades" runat="server" CausesValidation="False" ScriptEnabled="True" Style="display: none" />

                                        <rfn:RFNButton ID="btnMuestraDocumentoContrato" runat="server" CausesValidation="False"
                                            ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnMuestraDocumentoContratoProducto" runat="server" CausesValidation="False"
                                            ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnMuestraDocumentoContratoAutonomo" runat="server" CausesValidation="False"
                                            ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnMuestraDocumentoCargoCuenta" runat="server" CausesValidation="False"
                                            ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnMuestraDocumentoContratoDigital" runat="server" CausesValidation="False"
                                            ScriptEnabled="True" />
                                        <rfn:RFNButton ID="btnCargaDocumentos" runat="server" CausesValidation="False"
                                            ScriptEnabled="True" />
                                    </div>
                                </div>
                            </div>
                            <div class="subelementosSeccionPrincipalMostrarDoc">
                                <div class="elementosSeccionPrincipalMostrarDoc" style="margin-bottom: 15px">
                                    <div id="mostrarConsultarDocumentacion" style="display: none">
                                        <label id="btnCtrMostrarVersionDocumento" runat="server" style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 155px; display: inline-block; text-align: center; padding: 5px;">Mostrar Documentación</label>
                                    </div>
                                    <div id="PanelCtrPopHistDocumento" class="popupControlHistDocumento ocultarControl">
                                        <div class="subelementosSeccionPrincipalPadd2">
                                            <div class="control_derecha">
                                                <rfn:RFNImage ID="imgCtrCierrepopUpHistDocumento" runat="server" />
                                            </div>
                                            <div id="datosCtrHistDocumento" class="subelementosSeccionPrincipalHistDocumento">
                                                <fieldset id="fsCtrDatosHistDocumento" class="seccionesPrincipalesHistDocumento">
                                                    <legend>
                                                        <label id="lblCtrLegendHistDocumento" runat="server">Documentos Generados</label>
                                                    </legend>
                                                    <asp:UpdatePanel ID="UpCtrGridHistDocumento" runat="Server" UpdateMode="Conditional"
                                                        ChildrenAsTriggers="False">
                                                        <ContentTemplate>
                                                            <div class="subelementosSeccionPrincipalPadd2">
                                                                <rfn:RFNGridView ID="gvCtrDatosFicherosDigital" runat="server" AutoGenerateColumns="false"
                                                                    DataKeyNames="documentId">
                                                                    <Columns>
                                                                        <asp:BoundField DataField="idOhs" HeaderText="Id" Visible="false" />
                                                                        <asp:BoundField DataField="fileName" HeaderText="Nombre" />
                                                                        <asp:BoundField DataField="version" HeaderText="Versión" />
                                                                        <asp:BoundField DataField="createDate" HeaderText="Fecha" />
                                                                        <asp:BoundField DataField="user" HeaderText="Usuario" />
                                                                        <asp:BoundField DataField="signType" HeaderText="Tipo Firma" />
                                                                        <asp:TemplateField HeaderText="Área clientes">
                                                                            <ItemTemplate>
                                                                                <rfn:RFNCheckBox Checked='<%# Eval("web") %>' ID="web" runat="server" Visible='<%# Eval("mostrarWeb") %>' OnClientClick='<%# "CambioCheckWeb(this, " + CStr(Eval("idOhs")) + ");"%>'></rfn:RFNCheckBox>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="sendToOtpDate" Visible="false" HeaderText="Envío firma OTP" />
                                                                        <asp:TemplateField>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkFirmaOTP" runat="server" CausesValidation="false" CommandName="Firma"
                                                                                    Text="Firma Cliente OTP" Visible='<%# Eval("muestraFirma")%>' CommandArgument='<%# Eval("documentId") + "," + Eval("fileName")%> '>
                                                                                </asp:LinkButton>
                                                                                <asp:LinkButton ID="lnkCancelar" runat="server" CausesValidation="false" CommandName="Cancelar"
                                                                                    Text="Cancelar Firma OTP" Visible='<%# Eval("muestraCancelar")%>' CommandArgument='<%# Eval("documentId") + "," + Eval("fileName")%> '>
                                                                                </asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField>
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkDescargar" runat="server" CausesValidation="false" CommandName="DescargarDocumento"
                                                                                    Visible="true" CommandArgument='<%# Eval("documentId") + "," + Eval("fileName") + "," + CStr(Eval("version"))%> '> <img src="~/Recursos/Imagenes/descarga.png" alt="Descarga" runat="server" />                                                                     
                                                                                </asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField ShowHeader="False">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnkBusqSeleccionarDigital" runat="server" CausesValidation="false" CommandName="Eliminar"
                                                                                    Text="Eliminar" Visible='<%# Eval("muestraEliminar")%>' CommandArgument='<%# Eval("DocumentId")%> '>
                                                                                </asp:LinkButton>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </rfn:RFNGridView>
                                                            </div>
                                                            <div id="subirDocumento" class="subelementosSeccionPrincipalPadd2" style="display: none">
                                                                <div class="floatLeft" style="margin-right: 10px">
                                                                    <rfn:RFNFileUpload ID="fuDocumento" runat="server" Width="700px" />
                                                                    <div class="ocultarControl">
                                                                        <rfn:RFNButton ID="btnSubeDocumento" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                                                    </div>
                                                                </div>
                                                                <div class="floatLeft" style="margin-right: 10px">
                                                                    <rfn:RFNCheckBox ID="chkWebSubeDocumento" runat="server" Text="Área clientes" Enabled="True" ToolTip="Visibilidad en el Área de Clientes"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div class="floatLeft" style="margin-top: 3px">
                                                                    <label id="lblSubeDocumento" runat="server"
                                                                        style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 155px; display: inline-block; text-align: center; padding: 5px;">
                                                                        Subir Documentación
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </ContentTemplate>
                                                        <Triggers>
                                                            <asp:PostBackTrigger ControlID="btnSubeDocumento" />
                                                            <asp:AsyncPostBackTrigger ControlID="btnGeneraDocumento" EventName="Click" />
                                                            <asp:AsyncPostBackTrigger ControlID="btnGeneraCargoCuenta" EventName="Click" />
                                                        </Triggers>
                                                    </asp:UpdatePanel>
                                                </fieldset>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="mostrarCheckOtp" class="elementosSeccionPrincipalCercano" style="display: none; padding-left: 4px">
                                    <rfn:RFNCheckBox ID="chkGenerarFirmaOtp" runat="server" Text="Generar Documento Firma OTP"
                                        OnClientClick="CheckFirmaOtp" Enabled="True"></rfn:RFNCheckBox>
                                </div>
                                <div class="subelementosSeccionPrincipalMostrarDoc">
                                    <div class="elementosSeccionPrincipalMostrarDoc">
                                        <div id="mostrarConsultarObservaciones" style="display: none">
                                            <label id="btnoMbservaciones" runat="server"
                                                style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 155px; display: inline-block; text-align: center; padding: 5px;">
                                                Mostrar Observaciones
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="subelementosSeccionPrincipalMostrarDoc">
                                    <div class="elementosSeccionPrincipalMostrarDoc">
                                        <div id="mostrarConsultarActividaeds" style="display: none">
                                            <label id="btnMActividades" runat="server"
                                                style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 155px; display: inline-block; text-align: center; padding: 5px;">
                                                Mostrar Actividades
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="seccionCartaBaja" runat="server" class="subelementosSeccionPrincipalMostrarDoc">
                                <div id="mostrarConsultarCartaBaja" style="display: block">
                                    <label id="btnMostrarCartasBaja" runat="server"
                                        style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 155px; display: inline-block; text-align: center; padding: 5px;">
                                        Imprimir Baja
                                    </label>
                                </div>
                                <div id="PanelCtrPopCartasBaja" class="popupControlCartaBaja ocultarControl" style="display: none">
                                    <div class="subelementosSeccionPrincipalPadd3">
                                        <div class="control_derecha">
                                            <rfn:RFNImage ID="imgCtrCierrepopUpCartaBaja" runat="server" />
                                        </div>
                                        <div id="datosCtrCartasBaja" class="subelementosSeccionPrincipalHistDocumento">
                                            <fieldset id="fsCtrCartasBaja" class="seccionesPrincipalesHistDocumento">
                                                <contenttemplate>
                                                    <div class="subelementosSeccionPrincipalPadd3">
                                                        <div id="cartasBaja" runat="server" class="elementosSeccionPrincipalCercano">
                                                            <div id="generarCartaBaja" class="elementosSeccionPrincipalCercano">
                                                                <label id="lblGenerarCartaBaja" runat="server"
                                                                    style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 120px; display: inline-block; text-align: center; padding: 5px;">
                                                                    Rescisión Contrato
                                                                </label>
                                                            </div>
                                                            <div id="generarCartaBaja2" class="elementosSeccionPrincipalCercano">
                                                                <label id="lblGenerarCartaBaja2" runat="server"
                                                                    style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 155px; display: inline-block; text-align: center; padding: 5px;">
                                                                    Solicitud Fuera Plazo
                                                                </label>
                                                            </div>
                                                            <div id="generarCartaBaja3" class="elementosSeccionPrincipalCercano">
                                                                <label id="lblGenerarCartaBaja3" runat="server"
                                                                    style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 210px; display: inline-block; text-align: center; padding: 5px;">
                                                                    Solicitud Fuera Plazo morosidad
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </contenttemplate>
                                            </fieldset>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <fieldset id="fsCtrContrato" class="seccionesPrincipales_prueba">
                                <legend>
                                    <label id="lblLegendCtrContrato" runat="server">Contrato</label>
                                </legend>

                                <br />

                                <div class="subelementosSeccionPrincipal_prueba">
                                    <div class="elementosSeccionPrincipalCercano">
                                        <label id="lblCtrCodContrato" runat="server" for="txtCtrCodContrato" class="lblEtiquetas">Cod. Contrato</label>
                                        <rfn:RFNTextbox runat="server" ID="txtCtrCodContrato" CausesValidation="False" Style="text-align: right"
                                            Requerido="True" Enabled="False" CssClass="control_txt" Width="75px">
                                        </rfn:RFNTextbox>
                                    </div>

                                    <div class="elementosSeccionPrincipalCercano">
                                        <label id="lblCodContratoAsociado" runat="server" for="txtCodContratoAsociado" class="lblEtiquetas">Contrato Asociado</label>
                                        <rfn:RFNTextbox runat="server" ID="txtCodContratoAsociado" Requerido="False" Enabled="False"
                                            Width="100px" TipoDato="EnteroPositivo"></rfn:RFNTextbox>
                                    </div>

                                    <div class="elementosSeccionPrincipalCercano">
                                        <label id="lblContratoSAP" runat="server" for="txtContratoSAP" class="lblEtiquetas">Contrato SAP</label>
                                        <rfn:RFNTextbox runat="server" ID="txtContratoSAP" CausesValidation="False" Style="text-align: right"
                                            Requerido="True" Enabled="False" CssClass="control_txt" Width="95px">
                                        </rfn:RFNTextbox>
                                    </div>

                                    <div style="display: none">
                                        <rfn:RFNTextbox runat="server" ID="txtCtrIdContrato" CausesValidation="False" Style="text-align: right"
                                            Requerido="False" Enabled="False" CssClass="control_txt2">
                                        </rfn:RFNTextbox>
                                    </div>
                                    <div class="elementosSeccionPrincipalCercano">
                                        <label id="lblCtrEstadoContrato" runat="server" for="ddlCtrEstadoContrato" class="lblEtiquetas">Estado Contrato</label>
                                        <rfn:RFNDropDownList runat="server" ID="ddlCtrEstadoContrato" causesvalidation="True"
                                            ErrorMessage="Error Estado Contrato" Width="100px" OnClientChange="ActualizaFechaEstado"
                                            ValidationGroup="vGuardaContrato" PermitirVacio="False" Requerido="True" Enabled="True"
                                            CssClass="control_ddl">
                                        </rfn:RFNDropDownList>
                                    </div>
                                    <div id="contenedorCtrFecTerminado" class="elementosSeccionPrincipalCercano" style="display: none">
                                        <label id="lblCtrFecTerminado" runat="server" for="calFecTerminado" class="lblEtiquetas">Fecha Terminado</label>
                                        <rfn:RFNCalendar ID="calFecTerminado" runat="server" Enabled="False" Width="75px">
                                        </rfn:RFNCalendar>
                                    </div>
                                    <div id="contenedorCtrFecEstadoContrato" runat="server" class="elementosSeccionPrincipalCercano">
                                        <label id="lblCtrFecEstadoContrato" runat="server" for="calCtrFecEstadoContrato" class="lblEtiquetas">Fecha Último Estado</label>
                                        <rfn:RFNCalendar ID="calCtrFecEstadoContrato" runat="server" Enabled="False" ErrorMessage="Fecha de Estado Obligatoria"
                                            ValidationGroup="vGuardaContrato" Width="75px">
                                        </rfn:RFNCalendar>
                                    </div>
                                    <div id="contenedorCtrFecFirma1" runat="server" class="elementosSeccionPrincipalCercano">
                                        <label id="lblCtrFecFirma1" runat="server" for="calCtrFecFirma1" class="lblEtiquetas">Fecha de Firma</label>
                                        <rfn:RFNCalendar ID="calCtrFecFirma1" runat="server" Enabled="True" ErrorMessage="Fecha de Firma Obligatoria"
                                            ValidationGroup="vGuardaContrato" Width="75px" OnClientChange="cambioCtrFecFirma1"
                                            Requerido="True">
                                        </rfn:RFNCalendar>
                                    </div>
                                    <div style="display: none">
                                        <rfn:RFNDropDownList runat="server" ID="ddlCtrEstadoContratoOculto" Width="250px"
                                            PermitirVacio="False" CssClass="control_ddl">
                                        </rfn:RFNDropDownList>
                                        <rfn:RFNCalendar ID="calCtrFecEstadoContratoOculto" runat="server" Enabled="False"
                                            Style="display: none" Width="75px">
                                        </rfn:RFNCalendar>
                                    </div>
                                    <div style="display: none">
                                        <div class="elementosSeccionPrincipalCercano">
                                            <label id="lblEstadoPresupuesto" runat="server" for="ddlEstadoPresupuesto" class="lblEtiquetas">Estado Presupuesto</label>
                                            <rfn:RFNDropDownList runat="server" ID="ddlEstadoPresupuesto" causesvalidation="True"
                                                Width="250px" PermitirVacio="False" Requerido="True" CssClass="control_ddl" OnClientChange="ActualizaFechaEstado">
                                            </rfn:RFNDropDownList>
                                        </div>
                                        <div style="display: none">
                                            <rfn:RFNDropDownList runat="server" ID="ddlEstadoPresupuestoOculto" Width="250px"
                                                PermitirVacio="False" CssClass="control_ddl">
                                            </rfn:RFNDropDownList>
                                            <rfn:RFNCalendar ID="calFecEstadoPresupuestoOculto" runat="server" Enabled="False"
                                                Style="display: none" Width="75px">
                                            </rfn:RFNCalendar>
                                        </div>
                                        <div id="contenedorCtrFecEstadoPresupuesto" runat="server" class="elementosSeccionPrincipalCercano">
                                            <label id="lblCtrFecEstadoPresupuesto" runat="server" for="calFecEstadoPresupuesto" class="lblEtiquetas">Fecha de Estado</label>
                                            <rfn:RFNCalendar ID="calFecEstadoPresupuesto" runat="server" Enabled="False" Requerido="True"
                                                Width="75px">
                                            </rfn:RFNCalendar>
                                        </div>
                                    </div>
                                    <div class="elementosSeccionPrincipalCercano">
                                        <label id="lblImporteTotalContrato" runat="server" for="txtImporteTotalContrato" class="lblEtiquetas">Importe Total</label>
                                        <rfn:RFNTextbox runat="server" ID="txtImporteTotalContrato" CausesValidation="False"
                                            Style="text-align: right" Requerido="False" Enabled="False" CssClass="control_txt2"
                                            Width="75px">
                                        </rfn:RFNTextbox>
                                    </div>
                                    <div class="elementosSeccionPrincipalCercano">
                                        <label id="lblTipoContrato" runat="server" for="txtTipoContrato" class="lblEtiquetas">Tipo de Contrato</label>
                                        <rfn:RFNTextbox runat="server" ID="txtTipoContrato" CausesValidation="False" Style="text-align: right"
                                            Requerido="False" Enabled="False" CssClass="control_txt" Width="140px">
                                        </rfn:RFNTextbox>
                                    </div>

                                    <div class="subelementosSeccionPrincipal" style="padding-top: 5px">
                                        <div class="elementosSeccionPrincipalCercano" style="display: block">
                                            <label id="lblidioma" runat="server" for="ddlidioma" class="lblEtiquetas">Idioma</label>
                                            <rfn:RFNDropDownList ID="ddlidioma" runat="server" Width="192px" PermitirVacio="False"
                                                ErrorMessage="Error en Idioma" ValidationGroup="vGuardaPresupuesto" Requerido="True" OnClientChange="ActIdioma" />
                                        </div>
                                        <div id="estadoDocumento" class="elementosSeccionPrincipalCercano" runat="server" style="display: none">
                                            <label id="lblEstadoDocumento" runat="server" for="txtEstadoDocumento" class="lblEtiquetas">Estado firma OTP</label>
                                            <rfn:RFNTextbox runat="server" ID="txtEstadoDocumento" CausesValidation="False" Style="text-align: right"
                                                Requerido="False" Enabled="False" Width="100px">
                                            </rfn:RFNTextbox>
                                        </div>
                                        <div id="espacioEstadoDocumento" class="elementosSeccionPrincipalCercano" runat="server" style="width: 106px; display: block"></div>
                                        <div class="elementosSeccionPrincipalCercano" style="width: 232px"></div>

                                        <div class="elementosSeccionPrincipalCercano">
                                            <label id="lblCtrFecGeneracion" runat="server" for="calCtrFecGeneracion" class="lblEtiquetas">Fec. Generación</label>
                                            <rfn:RFNCalendar ID="calCtrFecGeneracion" runat="server" Enabled="False"></rfn:RFNCalendar>
                                        </div>

                                        <div class="elementosSeccionPrincipalCercano" style="display: none;">
                                            <label id="lblCtrVersionDocumento" runat="server" for="txtCtrVersionDocumento" class="lblEtiquetas">Versión</label>
                                            <rfn:RFNTextbox ID="txtCtrVersionDocumento" runat="server" Enabled="False" Width="50px"></rfn:RFNTextbox>
                                        </div>
                                        <div id="datosPresupuesto" class="elementosSeccionPrincipalCercano" style="display: none">
                                            <label id="lblCtrCodPresupuesto" runat="server" for="txtCtrCodPresupuesto" class="lblEtiquetas" style="font-weight: bold;">Ir a Pto.</label>
                                            <rfn:RFNTextbox runat="server" ID="txtCtrCodPresupuesto" CausesValidation="False"
                                                Style="text-align: right" Requerido="True" Enabled="False" CssClass="control_txt2"
                                                ToolTip="Consultar Presupuesto" Width="70px" BackColor="#009900" Font-Bold="True">
                                            </rfn:RFNTextbox>
                                            <div style="display: none">
                                                <rfn:RFNTextbox runat="server" ID="txtIdPresupuesto" CausesValidation="False" Style="text-align: right"
                                                    Requerido="False" Enabled="False" CssClass="control_txt2">
                                                </rfn:RFNTextbox>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <!-- START -->
                                <div class="subelementosSeccionPrincipalPadd8">
                                    <div id="nombreConsulta1" class="elementosSeccionPrincipal" style="display: inline">
                                        <label id="lblRazonSocial1" runat="server" for="ccdRazonSocial1" class="lblEtiquetas">Razón Social</label>
                                        <rfn:RFNCodDescripcion ID="ccdRazonSocial1" runat="server" Width="400px" CampoCodigo="COD_IDENTIFICADOR"
                                            CampoDescripcion="DES_RAZON_SOCIAL" FuenteDatos="SPA.S_CLIENTES" BusquedaAutomatica="True"
                                            MinCaracteresBusquedaAutomatica="5" Titulo="Razón Social" WidthCod="75px" TipoCodigo="Alfanumerico"
                                            ValidationGroup="" Proxy="wsControlesContratacion" NumElementos="50" Tipo="Procedimiento" Enabled="True"
                                            MaxLengthCodigo="10">
                                            <Columnas>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="ID_CLIENTE" HeaderText="ID. Cliente"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="true"
                                                    DataField="IND_AUTONOMO" HeaderText="Autónomo"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="DES_RAZON_SOCIAL_PIPES"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="COD_TIPO_EMPRESA"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="NUM_CONTRATOS"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="NUM_PRESUPUESTOS"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="COD_EMPPRL"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="DES_EMAIL"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="ID_GRUPO"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="COD_TIPO_IDENTIF"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="ID_DOMICILIO_SOCI"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="IND_GRAN_EMPRESA"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="ID_ACTIVIDAD"></rfn:ColumnaCodDescripcion>

                                            </Columnas>
                                        </rfn:RFNCodDescripcion>
                                    </div>
                                    <div class="elementosSeccionPrincipal">
                                        <label id="lblCentGest" runat="server" for="ccdCentroGestion" class="lblEtiquetas">Centro de Gestión</label>
                                        <rfn:RFNCodDescripcion ID="ccdCentroGestion" runat="server" Width="400px" CampoCodigo="COD_CENTRO_GEST"
                                            CampoDescripcion="DES_CENTRO_GEST" FuenteDatos="SPA.SCentrosGest_Read" BusquedaAutomatica="True"
                                            MinCaracteresBusquedaAutomatica="5" Titulo="Centros de Gestión" WidthCod="40px" TipoCodigo="Numerico"
                                            Proxy="wsControlesContratacion" NumElementos="50" Tipo="Procedimiento" SeleccionMultiple="False"
                                            Enabled="False" ViewStateMode="Enabled" OnClientChange="cambioCentroGestion" />
                                    </div>
                                    <div id="personaAlta" class="elementosSeccionPrincipal" style="display: none">
                                        <label id="lblPersonaAlta" runat="server" for="ccdPersonaAlta" class="lblEtiquetas">Comercial</label>
                                        <rfn:RFNCodDescripcion ID="ccdPersonaAlta" runat="server" CampoCodigo="COD_PERSONA"
                                            CampoDescripcion="NOM_PERSONA" FuenteDatos="SPA.Spersonas_Read" Width="350px" BusquedaAutomatica="True"
                                            MinCaracteresBusquedaAutomatica="5" Titulo="Persona responsable del presupuesto" Tipo="Procedimiento"
                                            WidthCod="50px" Proxy="wsControlesContratacion" NumElementos="50" TipoCodigo="Numerico" Enabled="true"
                                            SeleccionMultiple="False">
                                        </rfn:RFNCodDescripcion>
                                    </div>
                                </div>
                                <div class="subelementosSeccionPrincipalPadd8" style="margin-bottom: 0px;">
                                    <div class="elementosSeccionPrincipal" style="margin-right: 10px;">
                                        <label id="lblObservaciones" runat="server" for="txtCtrObservaciones" class="lblEtiquetas">Incidencias y Observaciones</label>
                                        <rfn:RFNTextbox ID="txtCtrObservaciones" runat="server" Width="430px" Height="30px" Requerido="False"
                                            MaxLength="500" TextMode="MultiLine" Enabled="False" />
                                    </div>


                                    <div class="elementosSeccionPrincipalPadd20" style="margin-top: 5px; margin-right: 10px;">
                                        <div class="subelementosSeccionPrincipal">
                                            <rfn:RFNCheckBox ID="chkAutonomo" runat="server" Text="Autónomo" Enabled="False"></rfn:RFNCheckBox>
                                        </div>
                                        <div class="subelementosSeccionPrincipal" style="width: 150px; display: block;">
                                            <rfn:RFNCheckBox ID="chkAAPP" runat="server" Text="Admin. Pública"></rfn:RFNCheckBox>
                                        </div>
                                    </div>




                                    <div class="elementosSeccionPrincipalPadd20" style="margin-top: 5px; margin-right: 20px;">
                                        <div class="subelementosSeccionPrincipal">
                                            <rfn:RFNCheckBox ID="chkCaptacionAAEE" runat="server" Text="Captacion AA.EE" Enabled="False"></rfn:RFNCheckBox>
                                        </div>
                                        <div class="subelementosSeccionPrincipal">
                                            <rfn:RFNCheckBox ID="RFNchkRenovable" runat="server" Text="Renovable" Enabled="True"
                                                OnClientClick="MirarRenovable"></rfn:RFNCheckBox>
                                        </div>
                                    </div>

                                    <div class="elementosSeccionPrincipal" style="margin-right: 10px; display: block">
                                        <label id="lblObservacionesTec" runat="server" for="txtCtrObservacionesTec" class="lblEtiquetas">Contacto y observaciones para prestación técnica</label>
                                        <rfn:RFNTextbox ID="txtCtrObservacionesTec" runat="server" Width="430px" Height="30px" Requerido="False"
                                            MaxLength="500" TextMode="MultiLine" Enabled="true" />
                                    </div>

                                    <div class="elementosSeccionPrincipal" style="margin-right: 10px; display: block">
                                        <label id="lblObservacionesMed" runat="server" for="txtCtrObservacionesMed" class="lblEtiquetas">Contacto y observaciones para prestación médica</label>
                                        <rfn:RFNTextbox ID="txtCtrObservacionesMed" runat="server" Width="430px" Height="30px" Requerido="False"
                                            MaxLength="500" TextMode="MultiLine" Enabled="true" />
                                    </div>



                                </div>

                                <br />
                                <div class="subelementosSeccionPrincipalPadd8 elementoFila99Por" id="observacionesMedycsaContrato" runat="server"
                                    style="margin-bottom: 0px; display: none">
                                    <div class="elementosSeccionPrincipal" style="margin-right: 10px;">
                                        <label id="lblHorasPerfilesMedycsa" runat="server" for="txtHorasPerfilesMedycsa" class="lblEtiquetas">Descripción horarios perfiles asistenciales / Dotaciones</label>
                                        <rfn:RFNTextbox ID="txtHorasPerfilesMedycsa" runat="server" Width="810px" Height="30px" Requerido="False"
                                            MaxLength="500" TextMode="MultiLine" Enabled="False" />
                                    </div>
                                </div>
                                <div class="subelementosSeccionPrincipal">
                                    <div class="elementosSeccionPrincipal">
                                        <label id="lblAltaGrupoCliente" runat="server" for="ccdGrupoCliente" class="lblEtiquetas">Grupo de Empresas</label>
                                        <rfn:RFNCodDescripcion ID="ccdGrupoCliente" runat="server" CampoCodigo="COD_GRUPO" CampoDescripcion="DES_GRUPO"
                                            FuenteDatos="SPA.SLineaNegocio_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                            Proxy="wsControlesContratacion" NumElementos="20" ErrorMessage="Error Grupo de Empresas"
                                            Tipo="Procedimiento" Width="260px" Requerido="False" Titulo="Grupo de Empresa"
                                            OnClientChange="cambioGrupoCliente" Enabled="False">
                                            <Columnas>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="ID_GRUPO"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="ID_LINEA"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="DES_LINEA"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="GESTOR" HeaderText="Gestor"></rfn:ColumnaCodDescripcion>
                                                <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                    DataField="IND_GC" HeaderText="Gestor"></rfn:ColumnaCodDescripcion>
                                            </Columnas>
                                        </rfn:RFNCodDescripcion>
                                    </div>
                                    <div class="elementosSeccionPrincipal">
                                        <label id="lblCeco" runat="server" for="txtCeco" class="lblEtiquetas">CECO</label>
                                        <rfn:RFNTextbox ID="txtCeco" Width="80px" runat="server" Enabled="false" Requerido="False"></rfn:RFNTextbox>
                                    </div>
                                    <div class="elementosSeccionPrincipal">
                                        <label id="lblLineaNegocio" runat="server" for="txtLineaNegocio" class="lblEtiquetas">Línea de Negocio</label>
                                        <rfn:RFNTextbox ID="txtLineaNegocio" Width="150px" runat="server" Enabled="false" Requerido="False">
                                        </rfn:RFNTextbox>
                                    </div>
                                    <div class="elementosSeccionPrincipal">
                                        <label id="lblGestor" runat="server" for="txtGestor" class="lblEtiquetas">Gestor</label>
                                        <rfn:RFNTextbox ID="txtGestor" Width="250px" runat="server" Enabled="false" Requerido="False"></rfn:RFNTextbox>
                                    </div>
                                </div>
                                <div class="elementosSeccionPrincipalCercano">
                                    <br />
                                </div>

                                <div class="subelementosSeccionPrincipal" runat="server" id="divMigrado" style="display: block">
                                    <div class="elementosSeccionPrincipal">
                                        <rfn:RFNCheckBox ID="Rfnchkmigrado" Text="Fecha Inicio Facturación" runat="Server" Enabled="false" />
                                    </div>
                                    <div class="elementosSeccionPrincipal" style="display: block">
                                        <rfn:RFNCalendar ID="rfncalmigrado" runat="server" Width="75px" Enabled="false" CausesValidation="True">
                                        </rfn:RFNCalendar>
                                    </div>
                                </div>

                                <div class="subelementosSeccionPrincipal" runat="server" id="divSuspendido" style="display: block">
                                    <table>
                                        <tr>
                                            <td>
                                                <div class="elementosSeccionPrincipal" style="display: block">
                                                    <label id="RFNLabel3" runat="server" class="lblEtiquetas">Fecha Suspendido</label>
                                                    <rfn:RFNCalendar ID="rfncalInicioSuspendido2" Width="75px" runat="server" Enabled="false"
                                                        CausesValidation="false" OnClientChange="CompruebaFechaInicio"
                                                        ErrorMessage="La fecha de suspensión es obligatroria" ValidationGroup="vGuardaContrato">
                                                    </rfn:RFNCalendar>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="elementosSeccionPrincipal" style="display: block">
                                                    <label id="RFNLabel4" runat="server" for="rfncalfinSuspendido" class="lblEtiquetas">Fecha Reactivación</label>
                                                    <rfn:RFNCalendar ID="rfncalfinSuspendido" runat="server" Width="75px" Enabled="false"
                                                        CausesValidation="True" OnClientChange="CompruebaFechaSuspendido"
                                                        ErrorMessage="La fecha de reactivación es obligatroria" ValidationGroup="vGuardaContrato">
                                                    </rfn:RFNCalendar>
                                                </div>
                                            </td>
                                        </tr>

                                    </table>



                                </div>




                                <div class="subelementosSeccionPrincipal">
                                    <div id="mostrarDesdeContrato" style="display: block">
                                        <label id="lblDesdeContrato" runat="server" style="border-width: 1px; border-color: black; background-color: #009900; color: white; display: inline-block; text-align: center; padding: 5px;">Obtener datos desde otro Contrato</label>
                                        <div id="PanelPopDesdeContrato" class="popupControlDesdeContrato" style="display: none">
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <div class="control_derecha">
                                                    <rfn:RFNImage ID="imgCierrepopUpDesdeContrato" runat="server" />
                                                </div>
                                                <div class="subelementosSeccionPrincipalDesdeContrato">
                                                    <div class="elementosSeccionPrincipal">
                                                        <label id="lblListadoContratos" runat="server" for="cmbListaContratosCliente" class="lblEtiquetas">Seleccione un Contrato</label>
                                                        <rfn:RFNDropDownList ID="cmbListaContratosCliente" runat="Server"
                                                            OnClientChange="mostrarDatosContratoDesde" PermitirVacio="True" Width="200px">
                                                        </rfn:RFNDropDownList>
                                                    </div>
                                                </div>
                                                <div id="datosDesdeContrato" class="subelementosSeccionPrincipalDesdeContrato" style="display: none">
                                                    <fieldset id="fsDatosDesdeContrato" class="seccionesPrincipales">
                                                        <legend>
                                                            <label id="Label1" runat="server"
                                                                style="border-width: 1px; border-color: black; background-color: #009900; color: white; display: inline-block; text-align: center; padding: 5px;">
                                                                Obtener datos desde otro Contrato
                                                            </label>
                                                        </legend>
                                                        <div class="subelementosSeccionPrincipalPadd2">
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <rfn:RFNCheckBox ID="chkMigrarContactos" runat="Server" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblMigrarContactos" runat="server">Migrar Contactos del Cliente</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <rfn:RFNCheckBox ID="chkMigrarFirmantesCliente" runat="Server" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblMigrarFirmantesCliente" runat="server">Migrar Firmantes del Cliente</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <rfn:RFNCheckBox ID="chkMigrarFirmantesSPFM" runat="Server" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblMigrarFirmantesSPFM" runat="server">Migrar Firmantes de QP</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <rfn:RFNButton ID="btnMigrarDatosContrato" runat="server" Text="Migrar"></rfn:RFNButton>
                                                            </div>
                                                        </div>
                                                    </fieldset>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                            <rfn:RFNPanel ID="grupoDatosCliente" runat="server" EstiloContenedor="False" Titulo="Otros Datos del Cliente"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <rfn:RFNValidationSummary ID="vsDomiSocial" runat="server" ShowMessageBox="False" ShowSummary="True"
                                    ValidationGroup="vGuardaDomiSocial"></rfn:RFNValidationSummary>
                                <fieldset id="fsDatosCliente" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendDatosCliente" runat="server">Otros Datos del Cliente</label>
                                    </legend>
                                    <div class="subelementosSeccionPrincipal">
                                        <div class="elementosSeccionPrincipal">
                                            <div id="nombreConsulta" class="subelementosSeccionPrincipalPadd2 elementoColumna">
                                                <label id="lblRazonSocial" runat="server" for="ccdRazonSocial" class="lblEtiquetas">Razón Social</label>
                                                <rfn:RFNCodDescripcion ID="ccdRazonSocial" runat="server" Width="400px"
                                                    CampoCodigo="COD_IDENTIFICADOR" CampoDescripcion="DES_RAZON_SOCIAL" FuenteDatos="SPA.S_CLIENTES"
                                                    BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Razón Social"
                                                    WidthCod="75px" TipoCodigo="Alfanumerico" ValidationGroup="" Proxy="wsControlesContratacion"
                                                    NumElementos="50" Tipo="Procedimiento" Enabled="True" MaxLengthCodigo="10"
                                                    OnClientChange="cambioRazSoc">
                                                    <Columnas>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="ID_CLIENTE" HeaderText="ID. Cliente"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="true" DataField="IND_AUTONOMO" HeaderText="Autónomo"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="DES_RAZON_SOCIAL_PIPES"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="COD_TIPO_EMPRESA"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="NUM_CONTRATOS"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="NUM_PRESUPUESTOS"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="COD_EMPPRL"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="DES_EMAIL"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="ID_GRUPO"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="COD_TIPO_IDENTIF"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="ID_DOMICILIO_SOCI"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="IND_GRAN_EMPRESA"></rfn:ColumnaCodDescripcion>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false"
                                                            MostrarEnGrid="false" DataField="ID_ACTIVIDAD"></rfn:ColumnaCodDescripcion>

                                                    </Columnas>
                                                </rfn:RFNCodDescripcion>
                                            </div>
                                        </div>
                                        <div class="elementosSeccionPrincipal">
                                            <div id="mostrarEmpresaFilial" class="subelementosSeccionPrincipalPadd2 elementoColumna ocultarControl">
                                                <label id="nifRazonSocialFilial" runat="server" for="nifFilial" class="lblEtiquetas"></label>
                                                <rfn:RFNTextbox ID="nifFilial" runat="server" Width="75px"
                                                    ErrorMessage="El CIF de la filial es obligatorio." ValidationGroup="vGuardaPresupuesto"
                                                    Requerido="False" Enabled="true"></rfn:RFNTextbox>
                                                <rfn:RFNTextbox ID="empresaFilial" runat="server" Width="350px"
                                                    ErrorMessage="La empresa de la filial es obligatoria." ValidationGroup="vGuardaPresupuesto"
                                                    Requerido="False" Enabled="true"></rfn:RFNTextbox>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="subelementosSeccionPrincipal">
                                        <div class="elementosSeccionPrincipal">
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <label id="lblActividad" runat="server" for="ccdActividad" class="lblEtiquetas">CNAE</label>
                                                <rfn:RFNCodDescripcion ID="ccdActividad" runat="server" CampoCodigo="COD_ACTIVIDAD"
                                                    CampoDescripcion="DES_ACTIVIDAD" FuenteDatos="SPA.Sactividades_Read" Width="500px"
                                                    ValidationGroup="vGuardaContrato" CausesValidation="True" ErrorMessage="Error en CNAE"
                                                    BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Actividad económica"
                                                    Proxy="wsControlesContratacion" NumElementos="50" Tipo="Procedimiento" Enabled="False">
                                                    <Columnas>
                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="ID_ACTIVIDAD"
                                                            DataField="ID_ACTIVIDAD" MostrarEnDescripcion="False" MostrarEnGrid="False" />
                                                    </Columnas>
                                                </rfn:RFNCodDescripcion>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="subelementosSeccionPrincipal">
                                        <fieldset id="fsDomicilioSocial" class="seccionesPrincipales">
                                            <legend>
                                                <label id="lblDomicilioSocial" runat="server">Domicilio Social del Contrato</label>
                                            </legend>
                                            <div style="display: none">
                                                <rfn:RFNButton ID="btnGrabaDomiSocial" runat="server" ValidationGroup="vGuardaDomiSocial"
                                                    CausesValidation="True"></rfn:RFNButton>
                                            </div>
                                            <asp:UpdatePanel ID="upDomiSocial" runat="server">
                                                <ContentTemplate>
                                                    <rfn:RFNHiddenField ID="hfTelefonoDS" runat="server" />
                                                    <rfn:RFNHiddenField ID="hfEmailDS" runat="server" />
                                                    <rfn:RFNHiddenField ID="hfFaxDS" runat="server" />
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="btnGrabarCentroDireFact" EventName="Click" />
                                                    <asp:AsyncPostBackTrigger ControlID="btnmodificacentro" EventName="Click" />
                                                    <asp:AsyncPostBackTrigger ControlID="btnGrabaDomiSocial" EventName="Click" />
                                                    <asp:AsyncPostBackTrigger ControlID="btnGeneraDocumento" EventName="Click" />
                                                    <asp:AsyncPostBackTrigger ControlID="btnGeneraCargoCuenta" EventName="Click" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                            <div id="mostrarGrabarDomiSocial" class="control_derecha mostrarControl">
                                                <label id="lblGrabarDomiSocial" runat="server" 
                                                    style="border-width: 1px; border-color: black; background-color: #009900; color: white; width: 150px; display: inline-block; text-align: center; padding: 5px;">
                                                    Grabar datos sociales
                                                </label>
                                            </div>
                                            <div class="subelementosSeccionPrincipal">
                                                <div class="elementosSeccionPrincipal">
                                                    <br />
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipal ocultarControl">
                                                            <rfn:RFNRadioButtonList ID="rblAltaColIndSocial" runat="server" CellPadding="0"
                                                                CellSpacing="0" RepeatDirection="Vertical" Requerido="True"
                                                                OnClientChange="cambioAltaColInd" Enabled="False">
                                                                <asp:ListItem Selected="True" Value="COLECTIVO">Colectivo</asp:ListItem>
                                                                <asp:ListItem Value="INDIVIDUAL">Individual</asp:ListItem>
                                                            </rfn:RFNRadioButtonList>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <div id="nombreAltaClienteSocial" runat="server" class="elementosSeccionPrincipal">
                                                                <div id="nomAltaColectivoSocial" runat="server" class="elementosSeccionPrincipal">
                                                                    <label id="lblAltaNombreCompletoSocial" runat="server" for="txtAltaNombreSocial" class="lblEtiquetas">Razón Social</label>
                                                                    <rfn:RFNTextbox ID="txtAltaNombreCompletoSocial" runat="server" Width="500px"
                                                                        CausesValidation="True" ErrorMessage="Error en Razón Social"
                                                                        ValidationGroup="vGuardaDomiSocial" Requerido="True" MaxLength="70">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div id="nomAltaIndividualSocial" runat="server"
                                                                    class="elementosSeccionPrincipalCercano" style="display: none">
                                                                    <label id="lblAltaNombreSocial" runat="server" for="txtAltaNombreSocial" class="lblEtiquetas">Nombre</label>
                                                                    <rfn:RFNTextbox ID="txtAltaNombreSocial" runat="server" Width="150px"
                                                                        CausesValidation="True" ErrorMessage="Error en Nombre"
                                                                        ValidationGroup="vGuardaDomiSocial" MaxLength="25"></rfn:RFNTextbox>
                                                                </div>
                                                                <div id="ape1AltaIndividualSocial" runat="server"
                                                                    class="elementosSeccionPrincipalCercano" style="display: none">
                                                                    <label id="lblAltaApellido1Social" runat="server" for="txtAltaApellido1Social" class="lblEtiquetas">Primer Apellido</label>
                                                                    <rfn:RFNTextbox ID="txtAltaApellido1Social" runat="server" Width="150px"
                                                                        CausesValidation="True" ErrorMessage="Error en Apellido 1"
                                                                        ValidationGroup="vGuardaDomiSocial" MaxLength="25"></rfn:RFNTextbox>
                                                                </div>
                                                                <div id="ape2AltaIndividualSocial" runat="server"
                                                                    class="elementosSeccionPrincipalCercano" style="display: none">
                                                                        <label id="lblAltaApellido2Social" runat="server" for="txtAltaApellido2Social" class="lblEtiquetas">Segundo Apellido</label>
                                                                    <rfn:RFNTextbox ID="txtAltaApellido2Social" runat="server" Width="150px"
                                                                        CausesValidation="True" ErrorMessage="Error en Apellido 2"
                                                                        ValidationGroup="vGuardaDomiSocial" MaxLength="20"></rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END -->
                                            <br />
                                            <div class="subelementosSeccionPrincipal">
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblProvinciaDS" runat="server" for="cmbProvinciaDS" class="lblEtiquetas">Provincia</label>
                                                    <rfn:RFNDropDownList ID="cmbProvinciaDS" runat="server" Width="192px" PermitirVacio="True"
                                                        OnClientChange="CambioProvinciaSocial" ValidationGroup="vGuardaDomiSocial" Requerido="True"
                                                        ErrorMessage="Error en Provincia" Enabled="False" />
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblPoblacionDS" runat="server" for="ccdPoblacionDS" class="lblEtiquetas">Población</label>
                                                    <rfn:RFNCodDescripcion ID="ccdPoblacionDS" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                        Width="300px" Requerido="True" ErrorMessage="Error en población" OnClientChange="CambioPoblacionSocial"
                                                        ValidationGroup="vGuardaDomiSocial" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población"
                                                        Tipo="Procedimiento" MostrarCodigo="False" CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION"
                                                        Proxy="wsControlesContratacion" NumElementos="50" Enabled="False">
                                                        <Columnas>
                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="ID_REGION" MostrarEnDescripcion="false"
                                                                MostrarEnGrid="False" />
                                                        </Columnas>
                                                    </rfn:RFNCodDescripcion>
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblCodPostalDS" runat="server" for="txtCPDS" class="lblEtiquetas">C.P.</label>
                                                    <rfn:RFNTextbox ID="txtCPDS" runat="server" Requerido="True" MaxLength="5" TipoDato="CodigoPostal"
                                                        ValidationGroup="vGuardaDomiSocial" Width="70px" ErrorMessage="Error en Código Postal"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipal">
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblViaDS" runat="server" for="cmbTipoViaDS" class="lblEtiquetas">Tipo de vía</label>
                                                    <rfn:RFNDropDownList ID="cmbTipoViaDS" runat="server" Width="192px" PermitirVacio="True"
                                                        ValidationGroup="vGuardaDomiSocial" Requerido="True" ErrorMessage="Error en tipo de vía"
                                                        Enabled="False" />
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblCalleDS" runat="server" for="txtCalleDS" class="lblEtiquetas">Calle</label>
                                                    <rfn:RFNTextbox ID="txtCalleDS" Width="331px" runat="server" OnClientChange="validaNumeroCaracteresDS"
                                                        ValidationGroup="vGuardaDomiSocial" Requerido="True" MaxLength="49" ErrorMessage="Error en Calle"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblNumeroDS" runat="server" for="txtNumDS" class="lblEtiquetas">Número</label>
                                                    <rfn:RFNTextbox ID="txtNumDS" Width="70px" runat="server" OnClientChange="validaNumeroCaracteresDS"
                                                        MaxLength="16" ErrorMessage="Error en Número"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                    <rfn:RFNTextbox ID="txtControlCaracteresConCalleDS" runat="server" Width="0px" Style="text-transform: uppercase"
                                                        CausesValidation="True" Requerido="false" ErrorMessage="El número de caracteres totales entre los campos: Calle, Número, Portal, Escalera, Piso y Puerta no puede exceder de 50"
                                                        ValidationGroup="vGuardaDomiSocial" MaxLength="40">
                                                    </rfn:RFNTextbox>
                                                    <rfn:RFNTextbox ID="txtControlCaracteresDS" runat="server" Width="0px" Style="text-transform: uppercase"
                                                        CausesValidation="True" Requerido="false" ErrorMessage="El número de caracteres totales entre los campos: Número, Portal, Escalera, Piso y Puerta no puede exceder de 16"
                                                        ValidationGroup="vGuardaDomiSocial" MaxLength="40">
                                                    </rfn:RFNTextbox>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipal">
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblPortalDS" runat="server" for="txtPortalDS" class="lblEtiquetas">Portal</label>
                                                    <rfn:RFNTextbox ID="txtPortalDS" OnClientChange="validaNumeroCaracteresDS" Width="50px"
                                                        runat="server" Requerido="False" MaxLength="4" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblEscaleraDS" runat="server" for="txtEscaleraDS" class="lblEtiquetas">Escalera</label>
                                                    <rfn:RFNTextbox ID="txtEscaleraDS" OnClientChange="validaNumeroCaracteresDS" Width="50px"
                                                        runat="server" MaxLength="4" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblPisoDS" runat="server" for="txtPisoDS" class="lblEtiquetas">Piso</label>
                                                    <rfn:RFNTextbox ID="txtPisoDS" OnClientChange="validaNumeroCaracteresDS" Width="50px"
                                                        runat="server" MaxLength="2" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblPuertaDS" runat="server" for="txtPuertaDS" class="lblEtiquetas">Puerta</label>
                                                    <rfn:RFNTextbox ID="txtPuertaDS" OnClientChange="validaNumeroCaracteresDS" Width="50px"
                                                        runat="server" MaxLength="2" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblNumTelfDS" runat="server" for="txtTelefonoDS" class="lblEtiquetas">Teléfono</label>
                                                    <rfn:RFNTextbox ID="txtTelefonoDS" Width="70px" runat="server" MaxLength="9" TipoDato="Telefono"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalDS">
                                                    <label id="lblNumFaxDS" runat="server" for="txtNumFaxDS" class="lblEtiquetas">Fax</label>
                                                    <rfn:RFNTextbox ID="txtNumFaxDS" Width="70px" runat="server" MaxLength="9" TipoDato="Telefono"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalDS2">
                                                    <label id="lblEmail" runat="server" for="txtEmailDS" class="lblEtiquetas">Email</label>
                                                    <rfn:RFNTextbox ID="txtEmailDS" Width="250px" runat="server" TipoDato="Texto" MaxLength="70"
                                                        ValidationGroup="vGuardaContrato" Requerido="True" ErrorMessage="El Email del cliente es obligatorio."
                                                        OnClientChange="CambiarEmailDS"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                        </fieldset>
                                        <%--     </div>
                        </fieldset>--%>

                                        <%--_CONTRATO_FILIAL--%>
                                        <div class="subelementosSeccionPrincipal" id="datospersonaFilial" runat="server" style="display: none">
                                            <fieldset id="fsFilial" class="seccionesPrincipales">
                                                <legend>
                                                    <label id="datosAsociadosFilial" runat="server" for="txtPersonaFilial" class="lblEtiquetas">Datos de Contacto asociados a filial</label>
                                                </legend>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <label id="lblPersonaFilial" runat="server" for="txtPersonaFilial" class="lblEtiquetas">Contacto del cliente</label>
                                                            <rfn:RFNTextbox ID="txtPersonaFilial" runat="server" Width="300px" CausesValidation="True"
                                                                ErrorMessage="Error Persona de contacto" ValidationGroup="vGuardaDomiSocial" MaxLength="100"></rfn:RFNTextbox>

                                                        </td>
                                                        <td>
                                                            <label id="lblTelefonoFilial" runat="server" for="txtTelefonoFilial" class="lblEtiquetas">Teléfono del cliente</label>
                                                            <rfn:RFNTextbox ID="txtTelefonoFilial" runat="server" Width="150px" CausesValidation="True"
                                                                ErrorMessage="Error teléfono de contacto" ValidationGroup="vGuardaDomiSocial" MaxLength="15" TipoDato="EnteroPositivo"></rfn:RFNTextbox>
                                                        </td>
                                                        <td>
                                                            <label id="lblEmailFilial" runat="server" for="txtEmailFilial" class="lblEtiquetas">Email del cliente</label>
                                                            <rfn:RFNTextbox ID="txtEmailFilial" runat="server" Width="300px" CausesValidation="True"
                                                                ErrorMessage="Error en mail de contacto" OnClientChange="compruebaEmail" ValidationGroup="vGuardaDomiSocial" MaxLength="100"></rfn:RFNTextbox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </fieldset>
                                        </div>
                                    </div>
                                </fieldset>

                            </rfn:RFNPanel>
                            <rfn:RFNPanel ID="grupoCtrFirma" runat="server" EstiloContenedor="False" Titulo="Firmantes"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <div class="subelementosSeccionPrincipalPadd2">
                                    <fieldset id="fsCtrContactos" class="seccionesPrincipales">
                                        <legend>
                                            <label id="lblLegendCtrContactos" runat="server">Contactos del Cliente</label>
                                        </legend>
                                        <div id="gridContactos" class="subelementosSeccionPrincipal centrosPresupuestoGrid"
                                            style="overflow: auto;">
                                            <rfn:RFNGridEditable2 ID="gvContactos" runat="server" GridLines="Both" CallBackFunction="manejadorGridContactos"
                                                wsProxy="wsControlesContratacion" wsProxyMetodo="AccionesGridContactos" AutoLoad="False" Font-Size="X-Small"
                                                Width="100%">
                                                <Configs>
                                                    <rfn:ConfigGE KeyNames="COD_CONTACTO, NOMBRE, APELLIDO1, APELLIDO2, DNI, CARGO, TELEFONO, EMAIL "
                                                        EnableAddRow="True" EnableDeleteRow="True" EnableEditRow="True" PosActionButtons="BOTH">
                                                        <Columnas>
                                                            <rfn:RFNLabelBound2 DataField="COD_CONTACTO" Visible="false" />
                                                            <rfn:RfnTextBoxBound2 DataField="NOMBRE" HeaderText="Nombre" Requerido="True" ErrorMessage="Error en Nombre"
                                                                MaxLength="20" />
                                                            <rfn:RfnTextBoxBound2 DataField="APELLIDO1" HeaderText="Apellido 1" Requerido="True"
                                                                ErrorMessage="Error en Apellido 1" MaxLength="20" />
                                                            <rfn:RfnTextBoxBound2 DataField="APELLIDO2" HeaderText="Apellido 2" MaxLength="20" />
                                                            <rfn:RfnTextIdentificadorBound2 DataField="DNI" HeaderText="Identificador" Requerido="True"
                                                                ValidarNIF="True" ValidarNIE="True" ValidarCIF="False" ErrorMessage="Error en Identificador" />
                                                            <rfn:RfnTextBoxBound2 DataField="CARGO" HeaderText="Cargo" MaxLength="30" Requerido="True"
                                                                ErrorMessage="Error en Cargo" />
                                                            <rfn:RfnTextBoxBound2 DataField="TELEFONO" HeaderText="Teléfono fijo" MaxLength="9" TipoDato="Telefono"
                                                                ErrorMessage="Error en Teléfono" />
                                                            <rfn:RfnTextBoxBound2 DataField="TELEFONOMOVIL" HeaderText="Móvil" MaxLength="9" TipoDato="Telefono"
                                                                ErrorMessage="Error en Teléfono" />
                                                            <rfn:RfnTextBoxBound2 DataField="EMAIL" HeaderText="E-Mail" TipoDato="Texto" ErrorMessage="Error en E-Mail"
                                                                MaxLength="70" />
                                                        </Columnas>
                                                    </rfn:ConfigGE>
                                                </Configs>
                                            </rfn:RFNGridEditable2>
                                        </div>
                                    </fieldset>
                                </div>
                                <div class="subelementosSeccionPrincipalPadd2">
                                    <fieldset id="fsCtrFirma" class="seccionesPrincipales">
                                        <legend>
                                            <label id="lblLegendCtrFirma" runat="server">Firmantes</label>
                                        </legend>
                                        <div class="subelementosSeccionPrincipalPaddMargen" style="display: none">
                                            <div id="contenedorCtrFecFirma" runat="server" class="elementosSeccionPrincipal"
                                                style="display: none">
                                                <label id="lblCtrFecFirma" runat="server" for="calCtrFecFirma" class="lblEtiquetas">Fecha de Firma</label>
                                                <rfn:RFNCalendar ID="calCtrFecFirma" runat="server" Enabled="True" ErrorMessage="Fecha de Firma Obligatoria"
                                                    ValidationGroup="vGuardaContrato" Width="75px" OnClientChange="cambioCtrFecFirma">
                                                </rfn:RFNCalendar>
                                            </div>
                                            <div class="elementosSeccionPrincipal" style="display: none">
                                                <label id="lblCtrCodContratoFirma" runat="server" for="txtCtrCodContratoFirma" class="lblEtiquetas">Cod. Contrato</label>
                                                <rfn:RFNTextbox runat="server" ID="txtCtrCodContratoFirma" CausesValidation="False"
                                                    Style="text-align: right" Requerido="True" Enabled="False" CssClass="control_txt">
                                                </rfn:RFNTextbox>
                                            </div>
                                            <div class="elementosSeccionPrincipal" style="display: none">
                                                <label id="lblCtrEstadoContratoFirma" runat="server" for="ddlCtrEstadoContratoFirma" class="lblEtiquetas">Estado Contrato</label>
                                                <rfn:RFNDropDownList runat="server" ID="ddlCtrEstadoContratoFirma" CausesValidation="True"
                                                    ErrorMessage="Error Estado Contrato" Width="150px" ValidationGroup="vGuardaContrato"
                                                    PermitirVacio="False" Requerido="True" Enabled="False" CssClass="control_ddl">
                                                </rfn:RFNDropDownList>
                                            </div>
                                            <div class="elementosSeccionPrincipal" style="display: none">
                                                <label id="lblCtrCodPresupuestoFirma" runat="server" for="txtCtrCodPresupuestoFirma" class="lblEtiquetas">Cod. Presupuesto</label>
                                                <rfn:RFNTextbox runat="server" ID="txtCtrCodPresupuestoFirma" CausesValidation="False"
                                                    Style="text-align: right" Requerido="True" Enabled="False" CssClass="control_txt">
                                                </rfn:RFNTextbox>
                                            </div>
                                        </div>
                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                            <fieldset id="fsCtrFirmaCliente" class="seccionesPrincipales">
                                                <legend>
                                                    <label id="lblCtrFirmaCliente" runat="server">Por parte del Cliente</label>
                                                </legend>
                                                <div class="subelementosSeccionPrincipalPaddMargen">
                                                    <fieldset id="fsCtrFirmaClienteRepresentante1" class="seccionesPrincipales3">
                                                        <legend>
                                                            <label id="lblCtrFirmaClienteRepresentante1" runat="server">Primer Representante</label>
                                                        </legend>
                                                        <div class="subelementosSeccionPrincipal">
                                                            <rfn:RFNCodDescripcion ID="ccdPrimerRepresentante" runat="server" Width="350px" CampoCodigo="NUM_DNI_CIF" SeleccionMultiple="False"
                                                                CampoDescripcion="NOM_CONTACTO" FuenteDatos="Contratacion.Contrato.Web.ContratosWebServiceAjax.ObtenerFirmantes" BusquedaAutomatica="True"
                                                                MinCaracteresBusquedaAutomatica="5" ErrorMessage="El Firmante por parte del Cliente es obligatorio a causa del importe total del Contrato."
                                                                Titulo="Primer Representante" ValidationGroup="vGuardaContrato" Tipo="WebService" WidthCod="75px" TipoCodigo="AlfaNumerico" Enabled="True"
                                                                OnClientChange="cambioPrimerRepresentante">
                                                                <Columnas>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="COD_CONTACTO" MostrarEnDescripcion="false"
                                                                        MostrarEnGrid="False" />
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NOMBRE" MostrarEnDescripcion="false"
                                                                        MostrarEnGrid="False" />
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="DES_CARGO" MostrarEnDescripcion="True"
                                                                        MostrarEnGrid="True" HeaderText="Cargo" />
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="DES_EMAIL" MostrarEnDescripcion="True"
                                                                        MostrarEnGrid="True" HeaderText="Email" />
                                                                </Columnas>
                                                            </rfn:RFNCodDescripcion>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <label id="lblCtrApellido1Representante1" runat="server" for="txtCtrApellido1Representante1" class="lblEtiquetas">Primer Apellido</label>
                                                                <rfn:RFNTextbox ID="txtCtrApellido1Representante1" runat="server" Requerido="False"
                                                                    Width="100px" ErrorMessage="El Primer Apellido del Representante es obligatorio."
                                                                    MaxLength="20" ValidationGroup="vGuardaContrato" Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <label id="lblCtrApellido2Representante1" runat="server" for="txtCtrApellido2Representante1" class="lblEtiquetas">Segundo Apellido</label>
                                                                <rfn:RFNTextbox ID="txtCtrApellido2Representante1" runat="server" Requerido="False"
                                                                    Width="100px" ErrorMessage="El Segundo Apellido del Representante es obligatorio."
                                                                    MaxLength="20" ValidationGroup="vGuardaContrato" Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrNombreRepresentante1" runat="server" for="txtCtrNombreRepresentante1" class="lblEtiquetas">Nombre</label>
                                                                <rfn:RFNTextbox ID="txtCtrNombreRepresentante1" runat="server" MaxLength="20" Requerido="False"
                                                                    Width="100px" ErrorMessage="El Nombre del Representante es obligatorio." ValidationGroup="vGuardaContrato"
                                                                    Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrIdentificadorRepresentante1" runat="server" for="txtCtrIdentificadorRepresentante1" class="lblEtiquetas">DNI/CIF</label>
                                                                <rfn:RFNTextIdentificador ID="txtCtrIdentificadorRepresentante1" runat="server" MaxLength="10"
                                                                    ValidationGroup="vGuardaContrato" ErrorMessage="El DNI/CIF del Representante no es válido."
                                                                    Width="75px" ValidarNIF="True" ValidarCIF="True" Enabled="False">
                                                                </rfn:RFNTextIdentificador>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrCargoRepresentante1" runat="server" for="txtCtrCargoRepresentante1" class="lblEtiquetas">Cargo</label>
                                                                <rfn:RFNTextbox ID="txtCtrCargoRepresentante1" runat="server" ErrorMessage="El Cargo del Representante es obligatorio."
                                                                    ValidationGroup="vGuardaContrato" Enabled="False" Width="175px" CausesValidation="True">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrEmailRepresentante1" runat="server" for="txtCtrEmailRepresentante1" class="lblEtiquetas">Email</label>
                                                                <rfn:RFNTextbox ID="txtCtrEmailRepresentante1" runat="server"
                                                                    Enabled="False" Width="300px" CausesValidation="True">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <fieldset id="fsCtrFirmaClienteNotario1" class="seccionesPrincipales">
                                                                <legend>
                                                                    <label id="lblCtrFirmaClienteNotario1" runat="server">Notario</label>
                                                                </legend>
                                                                <div class="control_derecha">
                                                                    <rfn:RFNCheckBox ID="chkTextoNotario1" runat="server" Text="Texto Libre" Enabled="False"
                                                                        OnClientClick="cambioTextoNotario1"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div id="panelDatosNotario1" style="display: block">
                                                                    <div class="subelementosSeccionPrincipalPaddMargen">
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrApellido1Notario1" runat="server" for="txtCtrApellido1Notario1" class="lblEtiquetas">Primer Apellido</label>
                                                                            <rfn:RFNTextbox ID="txtCtrApellido1Notario1" runat="server" Requerido="False" Width="125px"
                                                                                ErrorMessage="El Primer Apellido del Notario1 es obligatorio." MaxLength="20"
                                                                                ValidationGroup="vGuardaContrato" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrApellido2Notario1" runat="server" for="txtCtrApellido2Notario1" class="lblEtiquetas">Segundo Apellido</label>
                                                                            <rfn:RFNTextbox ID="txtCtrApellido2Notario1" runat="server" Requerido="False" Width="125px"
                                                                                ErrorMessage="El Segundo Apellido del Notario1 es obligatorio." MaxLength="20"
                                                                                ValidationGroup="vGuardaContrato" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrNombreNotario1" runat="server" for="txtCtrNombreNotario1" class="lblEtiquetas">Nombre</label>
                                                                            <rfn:RFNTextbox ID="txtCtrNombreNotario1" runat="server" MaxLength="20" Requerido="False"
                                                                                Width="125px" ErrorMessage="El Nombre del Notario1 es obligatorio." ValidationGroup="vGuardaContrato"
                                                                                Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="subelementosSeccionPrincipalPaddMargen">
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrPoblacionNotario1" runat="server" for="ccdCtrPoblacionNotario1" class="lblEtiquetas">Población</label>
                                                                            <rfn:RFNCodDescripcion ID="ccdCtrPoblacionNotario1" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                                                Width="260px" Requerido="False" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población"
                                                                                Tipo="Procedimiento" MostrarCodigo="False" CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION"
                                                                                Proxy="wsControlesContratacion" NumElementos="50" OnClientChange="CambioPoblacionNotario1" Enabled="False">
                                                                                <Columnas>
                                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="ID_REGION" MostrarEnDescripcion="false"
                                                                                        MostrarEnGrid="False" />
                                                                                </Columnas>
                                                                            </rfn:RFNCodDescripcion>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblProvinciaNotario1" runat="server" for="cmbProvinciaNotario1" class="lblEtiquetas">Provincia</label>
                                                                            <rfn:RFNDropDownList ID="cmbProvinciaNotario1" runat="server" Width="150px" PermitirVacio="True"
                                                                                Requerido="False" DataTextField="DESCRIPCION" DataValueField="ID_REGION" OnClientChange="CambioProvinciaNotario1"
                                                                                Enabled="False" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="subelementosSeccionPrincipalPaddMargen">
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrProtocoloNotario1" runat="server" for="txtCtrProtocoloNotario1" class="lblEtiquetas">Protocolo</label>
                                                                            <rfn:RFNTextbox ID="txtCtrProtocoloNotario1" class="control_derecha" runat="server"
                                                                                MaxLength="27" Width="60px" Enabled="False" TipoDato="EnteroPositivo">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblFecPoderNotario1" runat="server" for="calFecPoderNotario1" class="lblEtiquetas">Fecha Poder</label>
                                                                            <rfn:RFNCalendar ID="calFecPoderNotario1" runat="server" Enabled="False" Width="75px"></rfn:RFNCalendar>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div id="panelTextoNotario1" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtTextoNotario1" runat="server" Width="500px" Height="30px"
                                                                        ErrorMessage="El Texto del Notario1 es obligatorio." ValidationGroup="vGuardaContrato"
                                                                        Requerido="False" MaxLength="8000" TextMode="MultiLine" Text="asegurando que las facultades contenidas no le han sido revocadas, suspendidas ni limitadas"
                                                                        Enabled="False" />
                                                                </div>
                                                            </fieldset>
                                                        </div>
                                                    </fieldset>
                                                    <rfn:RFNImage ID="btnCtrEliminaRepresentante" class="control_derecha" Style="display: none"
                                                        runat="server" TextAlign="Left" ToolTip="Eliminar Representante"></rfn:RFNImage>
                                                    <rfn:RFNImage ID="btnCtrInsertaRepresentante" class="control_derecha" Style="display: block"
                                                        runat="server" TextAlign="Left" ToolTip="Insertar Representante"></rfn:RFNImage>
                                                </div>
                                                <div id="mostrarRepresentante2" style="display: none" class="subelementosSeccionPrincipalPaddMargen">
                                                    <fieldset id="fsCtrFirmaClienteRepresentante2" class="seccionesPrincipales3">
                                                        <legend>
                                                            <label id="lblCtrFirmaClienteRepresentante2" runat="server">Segundo Representante</label>
                                                        </legend>
                                                        <div class="subelementosSeccionPrincipal">
                                                            <rfn:RFNCodDescripcion ID="ccdSegundoRepresentante" runat="server" Width="350px" CampoCodigo="NUM_DNI_CIF" SeleccionMultiple="False"
                                                                CampoDescripcion="NOM_CONTACTO" FuenteDatos="Contratacion.Contrato.Web.ContratosWebServiceAjax.ObtenerFirmantes" BusquedaAutomatica="True"
                                                                MinCaracteresBusquedaAutomatica="5" ErrorMessage="El Firmante por parte del Cliente es obligatorio a causa del importe total del Contrato."
                                                                Titulo="Segundo Representante" ValidationGroup="vGuardaContrato" Tipo="WebService" WidthCod="75px" TipoCodigo="AlfaNumerico" Enabled="True"
                                                                OnClientChange="cambioSegundoRepresentante">
                                                                <Columnas>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="COD_CONTACTO" MostrarEnDescripcion="false"
                                                                        MostrarEnGrid="False" />
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NOMBRE" MostrarEnDescripcion="false"
                                                                        MostrarEnGrid="False" />
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="DES_CARGO" MostrarEnDescripcion="True"
                                                                        MostrarEnGrid="True" HeaderText="Cargo" />
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="DES_EMAIL" MostrarEnDescripcion="True"
                                                                        MostrarEnGrid="True" HeaderText="Email" />
                                                                </Columnas>
                                                            </rfn:RFNCodDescripcion>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <label id="lblCtrApellido1Representante2" runat="server" for="txtCtrApellido1Representante2" class="lblEtiquetas">Primer Apellido</label>
                                                                <rfn:RFNTextbox ID="txtCtrApellido1Representante2" runat="server" Requerido="False"
                                                                    Width="100px" ErrorMessage="El Primer Apellido del Representante es obligatorio."
                                                                    MaxLength="20" ValidationGroup="vGuardaContrato" Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <label id="lblCtrApellido2Representante2" runat="server" for="txtCtrApellido2Representante2" class="lblEtiquetas">Segundo Apellido</label>
                                                                <rfn:RFNTextbox ID="txtCtrApellido2Representante2" runat="server" Requerido="False"
                                                                    Width="100px" ErrorMessage="El Segundo Apellido del Representante es obligatorio."
                                                                    MaxLength="20" ValidationGroup="vGuardaContrato" Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrNombreRepresentante2" runat="server" for="txtCtrNombreRepresentante2" class="lblEtiquetas">Nombre</label>
                                                                <rfn:RFNTextbox ID="txtCtrNombreRepresentante2" runat="server" MaxLength="20" Requerido="False"
                                                                    Width="100px" ErrorMessage="El Nombre del Representante es obligatorio." ValidationGroup="vGuardaContrato"
                                                                    Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrIdentificadorRepresentante2" runat="server" for="txtCtrIdentificadorRepresentante2" class="lblEtiquetas">DNI/CIF</label>
                                                                <rfn:RFNTextIdentificador ID="txtCtrIdentificadorRepresentante2" runat="server" MaxLength="10"
                                                                    ErrorMessage="El DNI/CIF del Representante no es válido." Width="75px" ValidarCIF="True"
                                                                    ValidarNIF="True" Enabled="False">
                                                                </rfn:RFNTextIdentificador>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrCargoRepresentante2" runat="server" for="txtCtrCargoRepresentante2" class="lblEtiquetas">Cargo</label>
                                                                <rfn:RFNTextbox ID="txtCtrCargoRepresentante2" runat="server" MaxLength="27" Width="100px"
                                                                    Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrEmailRepresentante2" runat="server" for="txtCtrEmailRepresentante2" class="lblEtiquetas">Email</label>
                                                                <rfn:RFNTextbox ID="txtCtrEmailRepresentante2" runat="server"
                                                                    Enabled="False" Width="300px" CausesValidation="True">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <fieldset id="fsCtrFirmaClienteNotario2" class="seccionesPrincipales">
                                                                <legend>
                                                                    <label id="lblCtrFirmaClienteNotario2" runat="server">Notario</label>
                                                                </legend>
                                                                <div class="control_derecha">
                                                                    <rfn:RFNCheckBox ID="chkTextoNotario2" runat="server" Text="Texto Libre" Enabled="False"
                                                                        OnClientClick="cambioTextoNotario2"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div id="panelDatosNotario2" style="display: block">
                                                                    <div class="subelementosSeccionPrincipalPaddMargen">
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrApellido1Notario2" runat="server" for="txtCtrApellido1Notario2" class="lblEtiquetas">Primer Apellido</label>
                                                                            <rfn:RFNTextbox ID="txtCtrApellido1Notario2" runat="server" Requerido="False" Width="125px"
                                                                                ErrorMessage="El Primer Apellido del Notario2 es obligatorio." MaxLength="20"
                                                                                ValidationGroup="vGuardaContrato" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrApellido2Notario2" runat="server" for="txtCtrApellido2Notario2" class="lblEtiquetas">Segundo Apellido</label>
                                                                            <rfn:RFNTextbox ID="txtCtrApellido2Notario2" runat="server" Requerido="False" Width="125px"
                                                                                ErrorMessage="El Segundo Apellido del Notario2 es obligatorio." MaxLength="20"
                                                                                ValidationGroup="vGuardaContrato" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrNombreNotario2" runat="server" for="txtCtrNombreNotario2" class="lblEtiquetas">Nombre</label>
                                                                            <rfn:RFNTextbox ID="txtCtrNombreNotario2" runat="server" MaxLength="20" Requerido="False"
                                                                                Width="125px" ErrorMessage="El Nombre del Notario2 es obligatorio." ValidationGroup="vGuardaContrato"
                                                                                Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="subelementosSeccionPrincipalPaddMargen">
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrPoblacionNotario2" runat="server" for="ccdCtrPoblacionNotario2" class="lblEtiquetas">Población</label>
                                                                            <rfn:RFNCodDescripcion ID="ccdCtrPoblacionNotario2" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                                                Width="300px" Requerido="False" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población"
                                                                                Tipo="Procedimiento" MostrarCodigo="False" CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION"
                                                                                Proxy="wsControlesContratacion" NumElementos="50" OnClientChange="CambioPoblacionNotario2" Enabled="False">
                                                                                <Columnas>
                                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="ID_REGION" MostrarEnDescripcion="false"
                                                                                        MostrarEnGrid="False" />
                                                                                </Columnas>
                                                                            </rfn:RFNCodDescripcion>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblProvinciaNotario2" runat="server" for="cmbProvinciaNotario2" class="lblEtiquetas">Provincia</label>
                                                                            <rfn:RFNDropDownList ID="cmbProvinciaNotario2" runat="server" Width="150px" PermitirVacio="True"
                                                                                Requerido="False" DataTextField="DESCRIPCION" DataValueField="ID_REGION" OnClientChange="CambioProvinciaNotario2"
                                                                                Enabled="False" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="subelementosSeccionPrincipalPaddMargen">
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblCtrProtocoloNotario2" runat="server" for="txtCtrProtocoloNotario2" class="lblEtiquetas">Protocolo</label>
                                                                            <rfn:RFNTextbox ID="txtCtrProtocoloNotario2" class="control_derecha" runat="server"
                                                                                MaxLength="27" Width="60px" Enabled="False" TipoDato="EnteroPositivo">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                        <div class="elementosSeccionPrincipal">
                                                                            <label id="lblFecPoderNotario2" runat="server" for="calFecPoderNotario2" class="lblEtiquetas">Fecha Poder</label>
                                                                            <rfn:RFNCalendar ID="calFecPoderNotario2" runat="server" Enabled="False" Width="75px"></rfn:RFNCalendar>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div id="panelTextoNotario2" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtTextoNotario2" runat="server" Width="500px" Height="30px"
                                                                        ErrorMessage="El Texto del Notario2 es obligatorio." ValidationGroup="vGuardaContrato"
                                                                        Requerido="False" MaxLength="8000" TextMode="MultiLine" Text="asegurando que las facultades contenidas no le han sido revocadas, suspendidas ni limitadas"
                                                                        Enabled="False" />
                                                                </div>
                                                            </fieldset>
                                                        </div>
                                                    </fieldset>
                                                </div>
                                            </fieldset>
                                        </div>
                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                            <fieldset id="fsCtrFirmaSPFM" class="seccionesPrincipales">
                                                <legend>
                                                    <label id="lblCtrFirmaSPFM" runat="server">Por parte de Quirón Prevención</label>
                                                </legend>
                                                <div class="subelementosSeccionPrincipalPaddMargen">
                                                    <fieldset id="fsCtrFirmaSPFMDirectivo1" class="seccionesPrincipales">
                                                        <legend>
                                                            <label id="lblCtrFirmaSPFMDirectivo1" runat="server">Primer Directivo</label>
                                                        </legend>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrDirectivo1" runat="server" for="ccdCtrDirectivo1" class="lblEtiquetas">Directivo</label>
                                                                <rfn:RFNCodDescripcion ID="ccdCtrDirectivo1" runat="server" Width="350px" CampoCodigo="COD_EMPLEADO"
                                                                    CampoDescripcion="NOM_EMPLEADO" FuenteDatos="SPA.SDirectivosQP_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                                    Titulo="Directivo" WidthCod="40px" ErrorMessage="El Firmante por parte de QP es obligatorio a causa del importe total del Contrato."
                                                                    ValidationGroup="vGuardaContrato" TipoCodigo="Numerico" Proxy="wsControlesContratacion" NumElementos="50"
                                                                    Tipo="Procedimiento" SeleccionMultiple="False" OnClientChange="cambioDirectivo1">
                                                                    <Columnas>
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NOM_PERSONA" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NUM_PODER" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="false" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NOM_NOTARIO" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="false" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="FEC_PODER" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="false" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="DES_CARGO" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="True" HeaderText="Cargo" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="EUR_IMPORTE" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" HeaderText="Importe" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="COD_PERSONA" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="IND_CARGO" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="CASO_ESPECIAL" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                    </Columnas>
                                                                </rfn:RFNCodDescripcion>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <div class="elementosSeccionPrincipalPadd">
                                                                <label id="lblCtrCargoDirectivo1" runat="server" for="txtCtrCargoDirectivo1" class="lblEtiquetas">Cargo</label>
                                                                <rfn:RFNTextbox ID="txtCtrCargoDirectivo1" runat="server" Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalPadd">
                                                                <label id="lblCtrPoderDirectivo1" runat="server" for="txtCtrPoderDirectivo1" class="lblEtiquetas">Poder</label>
                                                                <rfn:RFNTextbox ID="txtCtrPoderDirectivo1" runat="server" MaxLength="27" Width="75px"
                                                                    Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div id="contenedorCtrFecPoderDirectivo1" runat="server" class="elementosSeccionPrincipalPadd">
                                                                <label id="lblCtrFecPoderDirectivo1" runat="server" for="calCtrFecPoderDirectivo1" class="lblEtiquetas">Fecha Poder</label>
                                                                <rfn:RFNCalendar ID="calCtrFecPoderDirectivo1" runat="server" Enabled="False" ErrorMessage="Fecha Poder Directivo Obligatoria"
                                                                    ValidationGroup="vGuardaContrato" Width="75px">
                                                                </rfn:RFNCalendar>
                                                            </div>
                                                        </div>
                                                    </fieldset>
                                                    <rfn:RFNImage ID="btnCtrEliminaDirectivo" class="control_derecha" Style="display: none"
                                                        runat="server" TextAlign="Left" ToolTip="Eliminar Directivo"></rfn:RFNImage>
                                                    <rfn:RFNImage ID="btnCtrInsertaDirectivo" class="control_derecha" Style="display: block"
                                                        runat="server" TextAlign="Left" ToolTip="Insertar Directivo"></rfn:RFNImage>
                                                </div>
                                                <div id="mostrarDirectivo2" style="display: none" class="subelementosSeccionPrincipalPaddMargen">
                                                    <fieldset id="fsCtrFirmaSPFMDirectivo2" class="seccionesPrincipales">
                                                        <legend>
                                                            <label id="lblCtrFirmaSPFMDirectivo2" runat="server">Segundo Directivo</label>
                                                        </legend>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <div class="elementosSeccionPrincipal">
                                                                <label id="lblCtrDirectivo2" runat="server" for="ccdCtrDirectivo2" class="lblEtiquetas">Directivo</label>
                                                                <rfn:RFNCodDescripcion ID="ccdCtrDirectivo2" runat="server" Width="350px" CampoCodigo="COD_EMPLEADO"
                                                                    CampoDescripcion="NOM_EMPLEADO" FuenteDatos="SPA.SDirectivosQP_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                                    Titulo="Directivo" WidthCod="40px" ErrorMessage="El Firmante por parte de QP es obligatorio a causa del importe total del Contrato."
                                                                    ValidationGroup="vGuardaContrato" TipoCodigo="Numerico" Proxy="wsControlesContratacion" NumElementos="50"
                                                                    Tipo="Procedimiento" SeleccionMultiple="False" OnClientChange="cambioDirectivo2">
                                                                    <Columnas>
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NOM_PERSONA" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NUM_PODER" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="false" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="NOM_NOTARIO" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="false" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="FEC_PODER" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="false" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="DES_CARGO" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="True" HeaderText="Cargo" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="EUR_IMPORTE" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" HeaderText="Importe" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="COD_PERSONA" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="IND_CARGO" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                        <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="CASO_ESPECIAL" MostrarEnDescripcion="false"
                                                                            MostrarEnGrid="False" />
                                                                    </Columnas>
                                                                </rfn:RFNCodDescripcion>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddMargen">
                                                            <div class="elementosSeccionPrincipalPadd">
                                                                <label id="lblCtrCargoDirectivo2" runat="server" for="txtCtrCargoDirectivo2" class="lblEtiquetas">Cargo</label>
                                                                <rfn:RFNTextbox ID="txtCtrCargoDirectivo2" runat="server" Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalPadd">
                                                                <label id="lblCtrPoderDirectivo2" runat="server" for="txtCtrPoderDirectivo2" class="lblEtiquetas">Poder</label>
                                                                <rfn:RFNTextbox ID="txtCtrPoderDirectivo2" runat="server" MaxLength="27" Width="75px"
                                                                    Enabled="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div id="contenedorCtrFecPoderDirectivo2" runat="server" class="elementosSeccionPrincipalPadd">
                                                                <label id="lblCtrFecPoderDirectivo2" runat="server" for="calCtrFecPoderDirectivo2" class="lblEtiquetas">Fecha Poder</label>
                                                                <rfn:RFNCalendar ID="calCtrFecPoderDirectivo2" runat="server" Enabled="False" ErrorMessage="Fecha Poder Directivo Obligatoria"
                                                                    ValidationGroup="vGuardaContrato" Width="75px">
                                                                </rfn:RFNCalendar>
                                                            </div>
                                                        </div>
                                                    </fieldset>
                                                </div>
                                            </fieldset>
                                        </div>
                                    </fieldset>
                                </div>
                            </rfn:RFNPanel>
                            <rfn:RFNPanel ID="grupoCtrColaborador" runat="server" EstiloContenedor="False" Titulo="Colaborador / Captación / Renovación del Contrato"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <fieldset id="fsCtrColaborador" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendCtrColaborador" runat="server">Colaborador</label>
                                    </legend>
                                    <div class="subelementosSeccionPrincipalPadd">

                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                            <rfn:RFNCheckBox ID="chkFcomi" runat="server" Text="Forzar Comisión" Font-Bold="False"></rfn:RFNCheckBox>
                                        </div>

                                        <div class="elementosSeccionPrincipal">
                                            <label id="lblCtrColaborador" runat="server" for="ccdCtrColaborador" class="lblEtiquetas">Colaborador</label>
                                            <rfn:RFNCodDescripcion ID="ccdCtrColaborador" runat="server" Width="500px" CampoCodigo="COD_COLABORADOR"
                                                OnClientChange="cambioccdCtrColaborador" CampoDescripcion="NOM_COLABORADOR" FuenteDatos="SPA.SColaboradores_Read"
                                                BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Colaborador" WidthCod="80px" TipoCodigo="Numerico"
                                                Proxy="wsControlesContratacion" NumElementos="34" Tipo="Procedimiento" SeleccionMultiple="False"
                                                Requerido="True" MaxLengthCodigo="6">
                                            </rfn:RFNCodDescripcion>
                                        </div>
                                        <div class="elementosSeccionPrincipal">
                                            <label id="lblHistColab" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White">Histórico de Colaboradores</label>
                                        </div>
                                    </div>
                                    <div class="subelementosSeccionPrincipalPadd2">
                                        <div id="contenedorCtrFecColabDesde" runat="server" class="elementosSeccionPrincipal">
                                            <label id="lblCtrFecColabDesde" runat="server" for="calCtrFecColabDesde" class="lblEtiquetas">Fecha Desde</label>
                                            <rfn:RFNCalendar ID="calCtrFecColabDesde" runat="server" Enabled="False" ErrorMessage="Fecha desde Colaborador Obligatoria"
                                                ValidationGroup="vGuardaContrato" OnClientChange="cambioFecColabDesde" Width="75px">
                                            </rfn:RFNCalendar>
                                        </div>
                                        <div class="elementosSeccionPrincipal">
                                            <label id="lblCtrPorcentajeColab" runat="server" for="txtCtrPorcentajeColab" class="lblEtiquetas">%</label>
                                            <rfn:RFNTextbox ID="txtCtrPorcentajeColab" Width="40px" runat="server" TipoDato="DecimalPositivo"
                                                MaxLength="6" Enabled="False" Requerido="True" ErrorMessage="Porcentaje de Colaborador Obligatorio"
                                                ValidationGroup="vGuardaContrato">
                                            </rfn:RFNTextbox>
                                        </div>
                                        <div class="elementosSeccionPrincipal">
                                            <label id="lblCtrTrimestreColab" runat="server" for="txtCtrTrimestreColab_1" class="lblEtiquetas">Desde Trimestre</label>
                                            <rfn:RFNTextbox ID="txtCtrTrimestreColab_1" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                MaxLength="6" Enabled="False" ErrorMessage="Trimestre de Colaborador Obligatorio"
                                                ValidationGroup="vGuardaContrato" MaxValue="4">
                                            </rfn:RFNTextbox>
                                            <rfn:RFNTextbox ID="txtCtrTrimestreColab_2" Width="100px" runat="server" TipoDato="EnteroPositivo"
                                                MaxLength="6" Enabled="False" ErrorMessage="Trimestre de Colaborador Obligatorio"
                                                ValidationGroup="vGuardaContrato">
                                            </rfn:RFNTextbox>
                                        </div>
                                    </div>
                                    <div id="PanelPopHistColab" class="popupControlHistColab" style="display: none">
                                        <div class="subelementosSeccionPrincipalPadd2">
                                            <div class="control_derecha">
                                                <rfn:RFNImage ID="imgCierrepopUpHistColab" runat="server" />
                                            </div>
                                            <div id="datosHistColab" class="subelementosSeccionPrincipalHistColab">
                                                <fieldset id="fsDatosHistColab" class="seccionesPrincipalesHistColab">
                                                    <legend>
                                                        <label id="lblLegendHistColab" runat="server">Datos de los Colaboradores</label>
                                                    </legend>
                                                    <div class="subelementosSeccionPrincipalPadd2">
                                                        <asp:UpdatePanel ID="UpGridHistColab" runat="Server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                                                            <ContentTemplate>
                                                                <rfn:RFNGridView ID="gvHistColab" runat="server" AutoGenerateColumns="False" DataKeyNames="COD_COLABORADOR, NOM_COLABORADOR, POR_COMISION, FEC_VINCULACION, SEM_PORCENTAJE, IND_ESTADO"
                                                                    AllowPaging="True" AllowSorting="True" Paginacion="PaginacionCacheada" CellPadding="1"
                                                                    PageSize="10" EnableSortingAndPagingCallbacks="True">
                                                                    <Columns>
                                                                        <asp:BoundField DataField="COD_COLABORADOR" HeaderText="Código Colaborador" SortExpression="COD_COLABORADOR"
                                                                            ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" />
                                                                        <asp:BoundField DataField="NOM_COLABORADOR" HeaderText="Nombre Colaborador" SortExpression="NOM_COLABORADOR"
                                                                            ItemStyle-Wrap="True" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" ItemStyle-Width="150px" />
                                                                        <asp:BoundField DataField="POR_COMISION" HeaderText="% Comisión" SortExpression="POR_COMISION"
                                                                            ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" />
                                                                        <asp:BoundField DataField="FEC_VINCULACION" HeaderText="Fecha Vinculación" SortExpression="FEC_VINCULACION"
                                                                            ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" />
                                                                        <asp:BoundField DataField="SEM_PORCENTAJE" HeaderText="Sem. Porcentaje" SortExpression="SEM_PORCENTAJE"
                                                                            ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" />
                                                                        <asp:BoundField DataField="FEC_USUARIO_ULTMOD" HeaderText="Fecha Modificación" SortExpression="FEC_USUARIO_ULTMOD"
                                                                            ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" />
                                                                        <asp:BoundField DataField="IND_ESTADO" HeaderText="Estado Contrato" SortExpression="IND_ESTADO"
                                                                            ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                            ItemStyle-VerticalAlign="Middle" />
                                                                    </Columns>
                                                                </rfn:RFNGridView>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>
                                <fieldset id="fsCtrRespCap" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendCtrRespCap" runat="server">Captación/Renovación del Contrato</label>
                                    </legend>
                                    <div class="elementoFila99Por">
                                        <div class="elementoColumna">
                                            <div class="lblEtiquetas">
                                                <rfn:RFNCheckBox runat="server" ID="chkGestionInterna" OnClientClick="cambioGestionInterna"
                                                    Text="Persona QP de Contacto - Gestión Interna" />
                                            </div>
                                            <rfn:RFNCodDescripcion ID="ccdCtrRespCaptacion" runat="server" Width="380px" CampoCodigo="COD_PERSONA"
                                                CampoDescripcion="NOM_PERSONA" FuenteDatos="SPA.Spersonas_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                Titulo="Responsable de Captación" WidthCod="80px" TipoCodigo="Numerico" Proxy="wsControlesContratacion"
                                                NumElementos="34" Tipo="Procedimiento" SeleccionMultiple="False" Requerido="True" ValidationGroup="vGuardaContrato"
                                                ErrorMessage="Debe informar el responsable de captación"
                                                OnClientChange="cambioRespCaptacion">
                                                <Columnas>
                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="DES_EMAIL" DataField="DES_EMAIL"
                                                        MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="IND_ACTIVO" HeaderText="ACTIVO" MostrarEnGrid="true" />
                                                </Columnas>
                                            </rfn:RFNCodDescripcion>
                                        </div>
                                        <div class="elementoColumna margenIzquierdo20">
                                            <br />
                                            <label id="lblCtrRespRenovacion" runat="server" for="ccdCtrRespRenovacion" class="lblEtiquetas">Persona QP de Contacto</label>
                                            <rfn:RFNCodDescripcion ID="ccdCtrRespRenovacion" runat="server" Width="380px" CampoCodigo="COD_PERSONA"
                                                CampoDescripcion="NOM_PERSONA" FuenteDatos="SPA.Spersonas_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                Titulo="Responsable de Renovación" WidthCod="80px" TipoCodigo="Numerico" Proxy="wsControlesContratacion"
                                                NumElementos="34" Tipo="Procedimiento" SeleccionMultiple="False" Requerido="False" OnClientChange="cambioRespRenovacion">
                                                <Columnas>
                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" DataField="IND_ACTIVO" HeaderText="ACTIVO" MostrarEnGrid="true" />
                                                </Columnas>
                                            </rfn:RFNCodDescripcion>
                                        </div>
                                    </div>
                                </fieldset>
                            </rfn:RFNPanel>
                            <asp:UpdatePanel ID="upCentrosTrabajo" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                <ContentTemplate>
                                    <div id="divOcultargrupoCentrosTrabajo" runat="server" style="display: block;">
                                        <rfn:RFNPanel ID="grupoCentrosTrabajo" runat="server" EstiloContenedor="False" Titulo="Centros de Trabajo"
                                            Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                            <fieldset id="fsCentrosTrabajo" class="seccionesPrincipales">
                                                <legend>
                                                    <label id="lblLegendCentrosTrabajo" runat="server">Centros de Trabajo</label>
                                                </legend>
                                                <div class="subelementosSeccionPrincipal">



                                                    <div runat="server" id="divdescargacentros">

                                                        <%--      <div id="divVacio" runat="server" class="elementoColumna300"> </div>
                                                <div id="div1" runat="server" class="elementoColumna300"> </div>--%>


                                                        <div id="divDescargarExcel" runat="server">
                                                            <div id="div4" runat="server">
                                                                <br />
                                                                <label id="RFNLabel6" runat="server" for="btnDescargarExcel" class="lblEtiquetas">Descargar Centros de Trabajo</label>
                                                                <br />
                                                            </div>
                                                            <div>
                                                                <div id="div3" runat="server" class="elementoColumna">
                                                                    <br />
                                                                    <rfn:RFNImage ID="btnDescargarExcel" runat="server" CausesValidation="false"
                                                                        ImageUrl="..\Recursos\Imagenes\Excel.png" ToolTip="Descarga los Centros de Trabajo a un fichero Excel" />
                                                                </div>
                                                                <rfn:RFNRadioButtonList ID="rblTipoExcel" runat="server" CellPadding="0" CellSpacing="0"
                                                                    Requerido="True" RepeatDirection="Vertical">
                                                                    <asp:ListItem Selected="True" Value="Cliente">Del cliente</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="Contrato">De este contrato</asp:ListItem>
                                                                    <asp:ListItem Selected="False" Value="Vacio">Vacío (Solo para nuevos centros)</asp:ListItem>
                                                                </rfn:RFNRadioButtonList>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <fieldset id="fsCentTotal" class="seccionesPrincipales">
                                                        <legend>
                                                            <label id="lblLegendCentrosTotal" runat="server">Número de centros</label>
                                                        </legend>
                                                        <div class="elementosSeccionPrincipal">
                                                            <rfn:RFNTextbox ID="txtcenttotal" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                MaxLength="6" Enabled="False" ToolTip="Centros"></rfn:RFNTextbox>
                                                        </div>
                                                        <div>
                                                            <rfn:RFNCheckBox ID="chkSinCentro" runat="server" Text="Sin Centro" Style="display: none" Enabled="False" />
                                                        </div>
                                                    </fieldset>
                                                    <fieldset id="fsTrabTotal" class="seccionesPrincipales">
                                                        <legend>
                                                            <label id="lblLegendTrabTotal" runat="server">Trabajadores Totales</label>
                                                        </legend>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblTrabOficina" runat="server" for="txtTrabOficina" class="lblEtiquetas" title="Bajo Riesgo">Oficina</label>
                                                            <rfn:RFNTextbox ID="txtTrabOficina" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                MaxLength="6" Enabled="False" ToolTip="Bajo Riesgo"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblTrabIndustria" runat="server" for="txtTrabIndustria" class="lblEtiquetas">Industria</label>
                                                            <rfn:RFNTextbox ID="txtTrabIndustria" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblTrabConstruccion" runat="server" for="txtTrabConstruccion" class="lblEtiquetas">Construcción</label>
                                                            <rfn:RFNTextbox ID="txtTrabConstruccion" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblTrabAnexo" runat="server" for="txtTrabAnexo" class="lblEtiquetas" title="Alto Riesgo">Anexo</label>
                                                            <rfn:RFNTextbox ID="txtTrabAnexo" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                MaxLength="6" Enabled="False" ToolTip="Alto Riesgo"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblTrabTotal" runat="server" for="txtTrabTotal" class="lblEtiquetas">Total</label>
                                                            <rfn:RFNTextbox ID="txtTrabTotal" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                    </fieldset>
                                                </div>


                                                <%--Filtros Centros de trabjo--%>

                                                <fieldset id="fsFiltrosCursos" class="seccionesFieldSetN5" runat="server" style="display: block">
                                                    <legend>
                                                        <label id="lblfiltrosCT" runat="server">Filtros de búsqueda</label>
                                                    </legend>
                                                    <div>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <label id="FlblProvincia" runat="server" class="etiqueta">Provincia</label>
                                                                    <rfn:RFNDropDownList ID="FcmbProvincia" runat="server" Width="192px" PermitirVacio="True"
                                                                        Requerido="False" DataTextField="DESCRIPCION" DataValueField="ID_REGION" OnClientChange="cambioRegionF" />

                                                                </td>
                                                                <td>

                                                                    <label id="FlblPoblacion" runat="server" class="etiqueta">Población</label>
                                                                    <rfn:RFNCodDescripcion ID="FccdPoblacion" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                                        Width="300px" Requerido="False" ErrorMessage="La Población es obligatoria"
                                                                        BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población" Tipo="Procedimiento" MostrarCodigo="False"
                                                                        CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION" Proxy="wsControlesContratacion" NumElementos="50">
                                                                    </rfn:RFNCodDescripcion>

                                                                </td>

                                                                <td>
                                                                    <label id="FlblCodPostalCentro" runat="server" for="TXTCP" class="lblEtiquetas">C.P.</label>
                                                                    <rfn:RFNTextbox runat="server" ID="TXTCP" Width="100px"></rfn:RFNTextbox>

                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <label id="lblfiltro3" runat="server" for="filtro3" class="lblEtiquetas">Referencia</label>

                                                                    <rfn:RFNTextbox runat="server" ID="filtro3" Width="300px"></rfn:RFNTextbox>


                                                                </td>
                                                                <td>
                                                                    <label id="lblfiltro2" runat="server" for="txtfiltroCodigo" class="lblEtiquetas">Código Centro Ventas</label>

                                                                    <rfn:RFNTextbox runat="server" ID="txtfiltroCodigo" Width="100px"></rfn:RFNTextbox>
                                                                </td>

                                                                <td>
                                                                    <label id="lblfiltro4" runat="server" for="txtfiltroCodigo" class="lblEtiquetas">Código Centro Prestación</label>

                                                                    <rfn:RFNTextbox runat="server" ID="txtfiltroCodigoP" Width="100px"></rfn:RFNTextbox>
                                                                </td>



                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                            </tr>

                                                            <tr>
                                                                <td>
                                                                    <label id="lblfltroCT" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 175px; pointer-events: none; opacity: 0.6">Buscar</label>

                                                                </td>

                                                                <td>
                                                                    <label id="lbllimpiarfiltroct" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 175px; pointer-events: none; opacity: 0.6">Limpiar campos</label>

                                                                </td>

                                                            </tr>
                                                        </table>
                                                    </div>


                                                </fieldset>

                                                <%--Fin filtros centros de trabajo  --%>

                                                <rfn:RFNGridEditable2 ID="gvCentrosTrabajo" runat="server" GridLines="Both" CssClass="borde_grid"
                                                    CallBackFunction="manejadorGridCentros" Width="895px" wsProxyMetodo="AccionesGridCentrosTrabajoContrato"
                                                    AutoLoad="False">
                                                    <Configs>
                                                        <rfn:ConfigGE KeyNames=" CAN_TRAB_OFI, CAN_TRAB_IND, CAN_TRAB_CONST, CAN_TRAB_ANEXO, CAN_TRAB_TOTAL, ID_CENPRES, ID_CENT_TRABAJ, DES_DOMICILIO_PIPES"
                                                            EnableAddRow="True" EnableDeleteRow="False" EnableEditRow="True" PosActionButtons="BOTH">
                                                            <Columnas>
                                                                <rfn:RFNLabelBound2 HeaderText="Oficina" DataField="CAN_TRAB_OFI" ImgHeader="Oficina.png"
                                                                    Width="30px" ToolTip="Bajo Riesgo" />
                                                                <rfn:RFNLabelBound2 HeaderText="Industria" DataField="CAN_TRAB_IND" ImgHeader="Industria.png"
                                                                    Width="30px" />
                                                                <rfn:RFNLabelBound2 HeaderText="Construcción" DataField="CAN_TRAB_CONST" ImgHeader="Construccion.png"
                                                                    Width="30px" />
                                                                <rfn:RFNLabelBound2 HeaderText="Anexo" DataField="CAN_TRAB_ANEXO" ImgHeader="Anexo.png"
                                                                    Width="30px" ToolTip="Alto Riesgo" />
                                                                <rfn:RFNLabelBound2 HeaderText="Trab. Total" DataField="CAN_TRAB_TOTAL" Width="30px" />
                                                                <rfn:RFNImageBound2 HeaderText="" Src="propio/detalle_grid.png" Width="30px" Name="Direccion" />
                                                                <rfn:RFNLabelBound2 HeaderText="Cod. Centro Ventas" DataField="" Width="40px"
                                                                    Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="Cod. Histórico" DataField="COD_HISTORICO" Width="30px"
                                                                    Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="Referencia" DataField="DES_REFERENCIA" Width="30px"
                                                                    Visible="True" />
                                                                <rfn:RFNLabelBound2 HeaderText="ID_ACTIVIDAD" DataField="ID_ACTIVIDAD" Width="30px"
                                                                    Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="DES_ACTIVIDAD_CENT" DataField="DES_ACTIVIDAD_CENT"
                                                                    Width="30px" Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="IND_PRIMER_CENTRO" DataField="IND_PRIMER_CENTRO"
                                                                    Width="30px" Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="ID_POBLACION" DataField="ID_POBLACION" Width="30px"
                                                                    Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="COD_POSTAL" DataField="COD_POSTAL" Width="30px" Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="ID_REGION" DataField="ID_REGION" Width="30px" Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="NUM_TELEFONO" DataField="NUM_TELEFONO" Width="30px"
                                                                    Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="NUM_FAX" DataField="NUM_FAX" Width="30px" Visible="False" />
                                                                <rfn:RfnTextBoxBound2 Editable="true" HeaderText="Dirección" DataField="DES_DOMICILIO" Width="300px" />
                                                                <rfn:RFNLabelBound2 HeaderText="Provincia" DataField="DES_PROVINCIA" Width="100px" />
                                                                <rfn:RFNLabelBound2 HeaderText="DES_DOMICILIO_PIPES" DataField="DES_DOMICILIO_PIPES"
                                                                    Width="30px" Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="FactParti" DataField="IND_ENV_FACT_PARTI" Width="30px"
                                                                    Visible="False" />
                                                                <rfn:RFNLabelBound2 HeaderText="Cod. Centro Ventas" DataField="COD_CENT_TRABAJ" Width="40px"
                                                                    Visible="True" />
                                                                <rfn:RFNLabelBound2 HeaderText="Cod. Centro Prestación" DataField="COD_CENT_TRABAJ_ORI" Width="40px"
                                                                    Visible="True" />
                                                            </Columnas>
                                                        </rfn:ConfigGE>
                                                    </Configs>
                                                </rfn:RFNGridEditable2>
                                    </div>
                                    <asp:Panel ID="PanelPopDomicilio" runat="server" Style="display: none">
                                        <fieldset id="fsCentro" class="elementosFsSeccionPrincipal">
                                            <legend>
                                                <label id="lblCentros" runat="server">Datos Centro de Trabajo</label>
                                            </legend>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblReferenciaDomi" runat="server" for="txtReferenciaDomi" class="lblEtiquetas">Referencia</label>
                                                    <rfn:RFNTextbox ID="txtReferenciaDomi" Width="300px" runat="server" Enabled="True"
                                                        Requerido="False">
                                                    </rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <rfn:RFNCheckBox ID="chkPrimerCentro" runat="server" Text="Primer Centro"></rfn:RFNCheckBox>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblActividadCentro" runat="server" for="ccdActividadCentro" class="lblEtiquetas">CNAE</label>
                                                    <rfn:RFNCodDescripcion ID="ccdActividadCentro" runat="server" CampoCodigo="COD_ACTIVIDAD"
                                                        CampoDescripcion="DES_ACTIVIDAD" FuenteDatos="SPA.Sactividades_Read" Width="500px"
                                                        BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Actividad económica" Proxy="wsControlesContratacion" NumElementos="50"
                                                        Tipo="Procedimiento">
                                                    </rfn:RFNCodDescripcion>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblProvincia" runat="server" class="etiqueta">Provincia</label><br />
                                                    <rfn:RFNDropDownList ID="cmbProvincia" runat="server" Width="192px" PermitirVacio="True"
                                                        Requerido="False" DataTextField="DESCRIPCION" DataValueField="ID_REGION" OnClientChange="CambioProvinciaCentro" />
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblPoblacion" runat="server" class="etiqueta">Población</label><br />
                                                    <rfn:RFNCodDescripcion ID="ccdPoblacion" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                        Width="300px" Requerido="False" ErrorMessage="La Población es obligatoria" ValidationGroup="GuardarCentro"
                                                        BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población" Tipo="Procedimiento" MostrarCodigo="False"
                                                        CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION" Proxy="wsControlesContratacion" NumElementos="50"
                                                        OnClientChange="CambioPoblacionCentro">
                                                    </rfn:RFNCodDescripcion>
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblCodPostalCentro" runat="server" for="cmbCodPostal" class="lblEtiquetas">C.P.</label>
                                                    <rfn:RFNDropDownList ID="cmbCodPostal" runat="server" Width="100px" PermitirVacio="True"
                                                        Requerido="False" DataTextField="DES_POSTAL" DataValueField="COD_POSTAL" Enabled="true">
                                                    </rfn:RFNDropDownList>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblVia" runat="server" class="etiqueta">Tipo de vía</label><br />
                                                    <rfn:RFNDropDownList ID="cmbTipoVia" runat="server" Width="192px" PermitirVacio="True"
                                                        Requerido="False" ValidationGroup="GuardarCentro" ErrorMessage="El tipo de vía es obligatorio" />
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblCalle" runat="server" class="etiqueta">Calle</label>
                                                    <rfn:RFNTextbox class="etiqueta" ID="txtCalle" Width="306px" runat="server" Requerido="False"
                                                        MaxLength="49"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <label id="lblNumero" runat="server" class="etiqueta">Número</label><br />
                                                    <rfn:RFNTextbox class="etiqueta" ID="txtNum" Width="130px" runat="server" Requerido="False"
                                                        MaxLength="16"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblPortal" runat="server" class="etiqueta">Portal</label><br />
                                                    <rfn:RFNTextbox class="etiqueta" ID="txtPortal" Width="50px" runat="server" Requerido="False"
                                                        MaxLength="4"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblEscalera" runat="server" class="etiqueta">Escalera</label><br />
                                                    <rfn:RFNTextbox ID="txtEscalera" Width="50px" runat="server" MaxLength="4"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblPiso" runat="server" class="etiqueta">Piso</label><br />
                                                    <rfn:RFNTextbox ID="txtPiso" Width="50px" runat="server" MaxLength="2"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblPuerta" runat="server" class="etiqueta">Puerta</label><br />
                                                    <rfn:RFNTextbox ID="txtPuerta" Width="70px" runat="server" MaxLength="2"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblNumTelf" runat="server" class="etiqueta">Teléfono</label><br />
                                                    <rfn:RFNTextbox ID="txtTelefono" Width="70px" runat="server" MaxLength="9" TipoDato="Telefono"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblNumFaxCentro" runat="server" class="etiqueta">Fax</label><br />
                                                    <rfn:RFNTextbox ID="txtFax" Width="70px" runat="server" MaxLength="9" TipoDato="Telefono"></rfn:RFNTextbox>
                                                </div>
                                                <div class="elementosSeccionPrincipalCercano" style="display: none">
                                                    <rfn:RFNButton ID="btnGrabarCentro" runat="server" Text="Grabar" CausesValidation="True"
                                                        ValidationGroup="GuardarCentro" OnClientClick="GuardaCentro"></rfn:RFNButton>
                                                </div>
                                            </div>

                                            <%--david--%>
                                            <div id="divgrcentro" runat="server" class="elementosSeccionPrincipal" clientidmode="Inherit" style="display: none">
                                                <label id="lblgrabarcentro" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 100px">Grabar</label>
                                            </div>
                                            <div id="factparti" runat="server" class="elementosSeccionPrincipal" clientidmode="Inherit" style="display: none">
                                                <rfn:RFNCheckBox ID="rfncheckFactparti" runat="server" Text="Particularizar datos de envío de facturas al Centro de Trabajo" Display="block" Enabled="true" OnClientClick="mostrarDireccionParti"></rfn:RFNCheckBox>

                                            </div>



                                            <%--  --%>

                                            <div class="subelementosSeccionPrincipal" id="idparti" runat="server" display="none">
                                                <fieldset id="fsCtrDirEnvFactP" class="seccionesPrincipales1009">
                                                    <%-- <legend>
                                                            <rfn:RFNCheckBox ID="chkParticularizar" runat="server" Text="Particularizar datos de envío de facturas al Centro de Trabajo"
                                                                Font-Bold="True" OnClientClick="cambioParticularizacion" Enabled="False" />
                                                        </legend>--%>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblProvinciaEnvFactP" runat="server" for="cmbProvinciaEnvFactP" class="lblEtiquetas">Provincia</label>
                                                            <rfn:RFNDropDownList ID="cmbProvinciaEnvFactP" runat="server" Width="192px" PermitirVacio="True"
                                                                ErrorMessage="Error en Provincia de la Dirección de envío de facturas" ValidationGroup="GuardaCentroTrabajoP"
                                                                Requerido="False" DataTextField="DESCRIPCION" DataValueField="ID_REGION" Enabled="False"
                                                                OnClientChange="cambioRegionCentroEnvFactP" />
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblPoblacionEnvFactP" runat="server" for="ccdPoblacionEnvFactP" class="lblEtiquetas">Población</label>
                                                            <rfn:RFNCodDescripcion ID="ccdPoblacionEnvFactP" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                                Width="300px" Requerido="False" ErrorMessage="Error en Población de la Dirección de envío de facturas"
                                                                ValidationGroup="GuardaCentroTrabajoP" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población"
                                                                Tipo="Procedimiento" MostrarCodigo="False" CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION"
                                                                Proxy="wsControlesContratacion" NumElementos="50" Enabled="True" OnClientChange="cambioPoblaCentroEnvFactP">
                                                            </rfn:RFNCodDescripcion>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblCodPostalEnvFactP" runat="server" for="cmbCPEnvFactP" class="lblEtiquetas">C.P.</label>
                                                            <rfn:RFNDropDownList ID="cmbCPEnvFactP" runat="server" Width="100px" PermitirVacio="True"
                                                                ErrorMessage="Error en Código Postal de la Dirección de envío de facturas" ValidationGroup="GuardaCentroTrabajoP"
                                                                Requerido="False" DataTextField="DES_POSTAL" DataValueField="COD_POSTAL" Enabled="False">
                                                            </rfn:RFNDropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblViaEnvFactP" runat="server" for="cmbTipoViaEnvFactP" class="lblEtiquetas">Tipo de vía</label>
                                                            <rfn:RFNDropDownList ID="cmbTipoViaEnvFactP" runat="server" Width="192px" PermitirVacio="True"
                                                                Requerido="False" ErrorMessage="Error en Tipo de Vía de la Dirección de envío de facturas"
                                                                ValidationGroup="GuardaCentroTrabajoP" DataTextField="DES_TIPO_VIA" DataValueField="COD_TIPO_VIA"
                                                                Enabled="False" />
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblCalleEnvFactP" runat="server" for="txtCalleEnvFactP" class="lblEtiquetas">Calle</label>
                                                            <rfn:RFNTextbox ID="txtCalleEnvFactP" Width="331px" runat="server" Requerido="False"
                                                                MaxLength="34" ErrorMessage="Error en Calle de la Dirección de envío de facturas"
                                                                ValidationGroup="GuardaCentroTrabajoP" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblNumeroEnvFactP" runat="server" for="txtNumEnvFactP" class="lblEtiquetas">Número</label>
                                                            <rfn:RFNTextbox ID="txtNumEnvFactP" Width="70px" runat="server" Requerido="False"
                                                                MaxLength="4" ErrorMessage="Error en Número de Calle de la Dirección de envío de facturas"
                                                                ValidationGroup="GuardaCentroTrabajoP" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblPortalEnvFactP" runat="server" for="txtPortalEnvFactP" class="lblEtiquetas">Portal</label>
                                                            <rfn:RFNTextbox ID="txtPortalEnvFactP" Width="50px" runat="server" Requerido="False"
                                                                MaxLength="4" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblEscaleraEnvFactP" runat="server" for="txtEscaleraEnvFactP" class="lblEtiquetas">Escalera</label>
                                                            <rfn:RFNTextbox ID="txtEscaleraEnvFactP" Width="50px" runat="server" MaxLength="4"
                                                                Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblPisoEnvFactP" runat="server" for="txtPisoEnvFactP" class="lblEtiquetas">Piso</label>
                                                            <rfn:RFNTextbox ID="txtPisoEnvFactP" Width="50px" runat="server" MaxLength="2" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblPuertaEnvFactP" runat="server" for="txtPuertaEnvFactP" class="lblEtiquetas">Puerta</label>
                                                            <rfn:RFNTextbox ID="txtPuertaEnvFactP" Width="70px" runat="server" MaxLength="2" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblNumTelfEnvFactP" runat="server" for="txtTelefonoEnvFactP" class="lblEtiquetas">Teléfono</label>
                                                            <rfn:RFNTextbox ID="txtTelefonoEnvFactP" Width="70px" runat="server" MaxLength="9"
                                                                TipoDato="Telefono" Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblNumFaxEnvFactP" runat="server" for="txtNumFaxEnvFactP" class="lblEtiquetas">Fax</label>
                                                            <rfn:RFNTextbox ID="txtNumFaxEnvFactP" Width="70px" runat="server" MaxLength="9" TipoDato="Telefono"
                                                                Enabled="False"></rfn:RFNTextbox>
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblAtencionEnvFactP" runat="server" for="txtAtencionEnvFactP" class="lblEtiquetas">A la atención de</label>
                                                            <rfn:RFNTextbox ID="txtAtencionEnvFactP" Width="300px" runat="server" CausesValidation="True"
                                                                ValidationGroup="GuardaCentroTrabajoP" ErrorMessage="Error en 'A la atención de' de la Dirección de envío de facturas"
                                                                Enabled="False" MaxLength="70"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblEmailEnvFactP" runat="server" for="txtEmailEnvFactP" class="lblEtiquetas">Dirección Email</label>
                                                            <rfn:RFNTextbox ID="txtEmailEnvFactP" Width="300px" runat="server" TipoDato="Texto" OnClientChange="compruebaEmail"
                                                                CausesValidation="True" ValidationGroup="GuardaCentroTrabajoP" ErrorMessage="Error en Email de la Dirección de envío de facturas"
                                                                Enabled="False" MaxLength="70">
                                                            </rfn:RFNTextbox>
                                                        </div>
                                                    </div>

                                                    <div class="elementosSeccionPrincipalCercano" style="display: block">
                                                        <rfn:RFNButton ID="btnGrabarCentroDireFact" runat="server" Text="Grabar Dirección" CausesValidation="True"
                                                            ValidationGroup="GuardaCentroTrabajoP" BorderWidth="1" BorderColor="Black" BackColor="#009900" ForeColor="White"
                                                            Visible="True"></rfn:RFNButton>
                                                    </div>
                                                </fieldset>
                                            </div>

                                            <%--  --%>
                                        </fieldset>
                                    </asp:Panel>
                                    </fieldset>
                                </rfn:RFNPanel>
                            </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="tlbCtrBarraPrincipal" EventName="BotonGuardarClick" />
                                </Triggers>
                            </asp:UpdatePanel>
                            <rfn:RFNPanel ID="grupoTarificacion" runat="server" EstiloContenedor="False" Titulo="Tarificación"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <br />
                                <div id="divOcultarapModalidades" runat="server" style="display: block;">
                                    <rfn:RFNPanel ID="apModalidades" runat="server" EstiloContenedor="False" Titulo="Modalidades"
                                        Visualizacion="Seccion" Collapsable="False" Collapsed="False" Width="100%" Display="table">
                                        <asp:UpdatePanel ID="upModalidades" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                            <ContentTemplate>
                                                <fieldset id="fsTarificacionModalidades" class="seccionesPrincipales5">
                                                    <legend>
                                                        <label id="lblLegendTarificacionModalidades" runat="server">Modalidades</label>
                                                    </legend>
                                                    <table style="border-collapse: collapse; width: 100%;">
                                                        <tr style="border-collapse: collapse; width: 100%;">
                                                            <td style="border-collapse: collapse;">
                                                                <div id="tarifaModalidad" class="subelementosSeccionPrincipalPadd">
                                                                    <label id="lblccdTarifaModalidad" runat="server" for="ccdTarifaModalidad" class="lblEtiquetas">Tarifa</label>
                                                                    <rfn:RFNCodDescripcion ID="ccdTarifaModalidad" runat="server" Width="600px" CampoCodigo="COD_TIP_TAR"
                                                                        CampoDescripcion="DES_TIP_TAR" FuenteDatos="SPA.Starifas_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                                        Titulo="Tarifas Modalidades" WidthCod="75px" Tipo="Procedimiento" NumElementos="50"
                                                                        TipoCodigo="Numerico" Proxy="wsControlesContratacion" Requerido="False" OnClientChange="CompruebaTarifa">
                                                                        <Columnas>
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="ID_TIP_TARIF" DataField="ID_TIP_TARIF"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="COD_TIP_TAR" DataField="COD_TIP_TAR"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DEFECTO" DataField="IND_DEFECTO"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_LIBRE" DataField="IND_LIBRE"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ESPECIFICA" DataField="IND_ESPECIFICA"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_TIPO_HORAS" DataField="IND_TIPO_HORAS"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_FACT_ANALITICA" DataField="IND_FACT_ANALITICA"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_FACT_RECONOCI" DataField="IND_FACT_RECONOCI"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_IPC" DataField="IND_IPC"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_GREMPRESAS" DataField="IND_GREMPRESAS"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IMP_OFICINA_REC" DataField="IMP_OFICINA_REC"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IMP_INDUSTRIA_REC" DataField="IMP_INDUSTRIA_REC"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IMP_CONSTRUCCION_REC" DataField="IMP_CONSTRUCCION_REC"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IMP_ANEXO_REC" DataField="IMP_ANEXO_REC"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="CAN_MIN_TRAB_RECO" DataField="CAN_MIN_TRAB_RECO"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_AUTONOMO" DataField="IND_AUTONOMO"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_POR_CENTRO" DataField="IND_POR_CENTRO"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="NUM_ANAL_PART" DataField="NUM_ANAL_PART"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="COD_MONEDA" DataField="COD_MONEDA"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_MICROPYME" DataField="IND_MICROPYME"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ADMITE_DESCUENTO" DataField="IND_ADMITE_DESCUENTO"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_CONTRATO_TOTAL" DataField="IND_CONTRATO_TOTAL"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_SOLO_PAGO_ANUAL" DataField="IND_SOLO_PAGO_ANUAL"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ALTA_ANEXOS" DataField="IND_ALTA_ANEXOS"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_POR_CENTRO_MATRIZ" DataField="IND_POR_CENTRO_MATRIZ"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_RECOS_PF" DataField="IND_RECOS_PF"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_RPF_MT" DataField="IND_RPF_MT"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_CENTRAL" DataField="IND_CENTRAL"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ADMIN" DataField="IND_ADMIN"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRPROV" DataField="IND_DIRPROV"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRTER" DataField="IND_DIRTER"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                            <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIROFI" DataField="IND_DIROFI"
                                                                                MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                        </Columnas>
                                                                    </rfn:RFNCodDescripcion>
                                                                    <rfn:RFNCheckBox ID="chkFormacionOnline" runat="server" Text="Formación Online" Display="none" Enabled="false"></rfn:RFNCheckBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <div class="elementosSeccionPrincipal">
                                                        <label id="lblhistTarifa" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White">Histórico de Tarifas</label>



                                                        <div id="PanelPopHistTarifa" class="popupControlHistTarifa" style="display: none">
                                                            <div class="subelementosSeccionPrincipalPadd2">
                                                                <div class="control_derecha">
                                                                    <rfn:RFNImage ID="imgCierrepopUpHistTarifa" runat="server" />
                                                                </div>
                                                                <div id="datosHistTarifa">
                                                                    <fieldset id="fsDatosHistTarifa">
                                                                        <legend>
                                                                            <label id="lblLegendHistTarifa" runat="server">Datos</label>
                                                                        </legend>
                                                                        <div class="subelementosSeccionPrincipalPadd2">
                                                                            <asp:UpdatePanel ID="UpGridHistTarifa" runat="Server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                                                                                <ContentTemplate>
                                                                                    <rfn:RFNGridView ID="gvHistTarifa" runat="server" AutoGenerateColumns="False" DataKeyNames="COD_TIP_TAR, FEC_USUARIO_ULTMOD, NOM_USUARIO_ULTMOD"
                                                                                        AllowPaging="True" AllowSorting="True" Paginacion="PaginacionCacheada" CellPadding="1"
                                                                                        PageSize="10" EnableSortingAndPagingCallbacks="True">
                                                                                        <Columns>
                                                                                            <asp:BoundField DataField="COD_TIP_TAR" HeaderText="Código de Tarifa" SortExpression="COD_TIP_TAR"
                                                                                                ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                                                ItemStyle-VerticalAlign="Middle" />
                                                                                            <asp:BoundField DataField="FEC_USUARIO_ULTMOD" HeaderText="Fecha Modificación" SortExpression="FEC_USUARIO_ULTMOD"
                                                                                                ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                                                ItemStyle-VerticalAlign="Middle" />
                                                                                            <asp:BoundField DataField="NOM_USUARIO_ULTMOD" HeaderText="Ususario" SortExpression="NOM_USUARIO_ULTMOD"
                                                                                                ItemStyle-Wrap="False" HeaderStyle-Wrap="False" ItemStyle-HorizontalAlign="Center"
                                                                                                ItemStyle-VerticalAlign="Middle" />
                                                                                        </Columns>
                                                                                    </rfn:RFNGridView>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </div>
                                                                    </fieldset>
                                                                </div>
                                                            </div>
                                                        </div>




                                                    </div>

                                                    <div class="elementoFila99Por">
                                                        <div class="elementoColumna">
                                                            <table style="border-collapse: collapse; margin-top: 25px;">
                                                                <tr style="border-collapse: collapse;">
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtDescTec" Width="80px" runat="server" TipoDato="DecimalPositivo"
                                                                            MaxLength="10" Enabled="False" ViewStateMode="Enabled" MaxValue="100"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse;">
                                                                        <label id="lblDescTec" runat="server" for="txtDescTec" style="width: 110px; pointer-events: none; opacity: 0.6; border-collapse: collapse;">%%Desc. Téc.</label>
                                                                    </td>
                                                                </tr>
                                                                <tr style="border-collapse: collapse;">
                                                                    <td style="border-collapse: collapse;">
                                                                        <rfn:RFNTextbox ID="txtDescTecHoras" Width="80px" runat="server" TipoDato="DecimalPositivo"
                                                                            MaxLength="10" Enabled="False" ViewStateMode="Enabled" MaxValue="100"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse;">
                                                                        <label id="lblDescTecHoras" runat="server" for="txtDescTecHoras" style="width: 110px">%Desc. Téc. Horas</label>
                                                                    </td>
                                                                </tr>
                                                                <tr style="border-collapse: collapse;">
                                                                    <td style="border-collapse: collapse;">
                                                                        <rfn:RFNTextbox ID="txtDescMed" Width="80px" runat="server" TipoDato="DecimalPositivo"
                                                                            MaxLength="10" Enabled="False" MaxValue="100"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse;">
                                                                        <label id="lblDescMed" runat="server" for="txtDescMed">%Desc. Méd.</label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <table>
                                                                <tr style="border-collapse: collapse;">
                                                                    <td style="border-collapse: collapse;">
                                                                        <div class="elementosSeccionPrincipalPadd">
                                                                            <label id="lblMotivoDescuento" runat="server" for="txtMotivoDescuento" class="lblEtiquetas">Motivo de Descuento</label>
                                                                            <rfn:RFNTextbox ID="txtMotivoDescuento" Width="150px" runat="server" Enabled="False"
                                                                                Visible="False">
                                                                            </rfn:RFNTextbox>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%--                   <div class="subelementosSeccionPrincipalPadd">
                                                <div class="elementosSeccionPrincipalPadd">--%>
                                                            <%-- <div class="subelementosSeccionPrincipalPadd">
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPadd">
                                                            <div class="elementoDescuento">
                                                                <rfn:RFNTextbox ID="txtDescTec" Width="80px" runat="server" TipoDato="DecimalPositivo"
                                                                    MaxLength="10" Enabled="False" ViewStateMode="Enabled" MaxValue="100"></rfn:RFNTextbox>
                                                                <label id="lblDescTec" runat="server" for="txtDescTecHoras" class="elementoDescuento" style="width: 80px; pointer-events: none; opacity: 0.6">%Desc. Téc. Horas</label>
                                                            </div>
                                                            <div class="elementoDescuento">
                                                                <rfn:RFNTextbox ID="txtDescTecHoras" Width="80px" runat="server" TipoDato="DecimalPositivo"
                                                                    MaxLength="10" Enabled="False" ViewStateMode="Enabled" MaxValue="100"></rfn:RFNTextbox>
                                                                <label id="lblDescTecHoras" runat="server" for="txtDescTec">%Desc. Téc. Horas</label>
                                                            </div>
                                                            <div class="elementoDescuento">
                                                                <rfn:RFNTextbox ID="txtDescMed" Width="80px" runat="server" TipoDato="DecimalPositivo"
                                                                    MaxLength="10" Enabled="False" MaxValue="100"></rfn:RFNTextbox>
                                                                <label id="lblMotivoDescuento" runat="server" for="txtMotivoDescuento" class="lblEtiquetas">Motivo de Descuento</label>
                                                            </div>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalPadd">
                                                            <label id="lblMotivoDescuento" runat="server" for="txtMotivoDescuento" class="lblEtiquetas">Motivo de Descuento</label>
                                                            <rfn:RFNTextbox ID="txtMotivoDescuento" Width="150px" runat="server" Enabled="False"
                                                                Visible="False">
                                                            </rfn:RFNTextbox>
                                                        </div>--%>
                                                            <%--                                 </div>--%>
                                                        </div>
                                                        <div class="elementoColumna">
                                                            <%--<div class="elementosSeccionPrincipalPadd3">--%>
                                                            <fieldset id="fsModalidades" class="seccionPrincipalModalidad">
                                                                <legend>
                                                                    <label id="lblModalidades" runat="server">Precios/Horas</label>
                                                                </legend>
                                                                <%--<div class="subelementosSeccionPrincipal">--%>
                                                                <table style="border-collapse: collapse;">
                                                                    <tr style="border-collapse: collapse;">
                                                                        <%--Fila de los cheks--%>
                                                                        <td style="border-collapse: collapse;"></td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNCheckBox ID="chkModST" runat="server" Text="ST"></rfn:RFNCheckBox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNCheckBox ID="chkModHI" runat="server" Text="HI"></rfn:RFNCheckBox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNCheckBox ID="chkModEP" runat="server" Text="EP"></rfn:RFNCheckBox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNCheckBox ID="chkModMT" runat="server" Text="MT"></rfn:RFNCheckBox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <label id="lblModTot" runat="server" for="txtModTot" class="lblEtiquetasPadd">Total</label>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <label id="lblModHorTec" runat="server" for="txtModHorTecDescuento" class="lblEtiquetasPadd">Horas Téc</label>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <label id="lblModHorMed" runat="server" for="txtModHorMedDescuento" class="lblEtiquetasPadd">Horas Méd</label>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="border-collapse: collapse; width: 100%; display: none">
                                                                        <%--Fila de las cajas de texto--%>
                                                                        <td style="border-collapse: collapse;">
                                                                            <label id="lblImporteTarifa" runat="server">Importe según Tarifa:</label>
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModST" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">        </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModHI" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModEP" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModMT" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModTot" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModHorTec" Width="50px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModHorMed" Width="50px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="border-collapse: collapse; width: 100%;">
                                                                        <%--Fila de las cajas de texto--%>
                                                                        <td style="border-collapse: collapse;">
                                                                            <label id="lblImporteTarifaDescuento" runat="server" style="width: 110px">Importe aplicado:</label>
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModSTDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModHIDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModEPDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModMTDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False">
                                                                            </rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModTotDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False"></rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModHorTecDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False"></rfn:RFNTextbox>
                                                                        </td>
                                                                        <td>&nbsp;
                                                                        </td>
                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txtModHorMedDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False"></rfn:RFNTextbox>
                                                                        </td>
                                                                    </tr>
                                                                    <%--<tr style="border-collapse: collapse; width: 100%;">--%>
                                                                    <tr>
                                                                        <td style="border-collapse: collapse">
                                                                            <label id="lblimporteqshd" runat="server" style="width: 110px;">Importe Hospital Digital: </label>
                                                                        </td>

                                                                        <td style="border-collapse: collapse">
                                                                            <rfn:RFNTextbox ID="txthd" Width="70px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False" Text="0,00"></rfn:RFNTextbox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <%--                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <label id="lblImporteTarifa" runat="server">Importe según Tarifa:</label>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <label id="lblModTot" runat="server" for="txtModTot" class="lblEtiquetasPadd" style="width: 70px; pointer-events: none; opacity: 0.6; display: none">Total</label>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNCheckBox ID="chkModST" runat="server" Text="ST"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModST" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModSTDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNCheckBox ID="chkModHI" runat="server" Text="HI"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModHI" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModHIDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNCheckBox ID="chkModEP" runat="server" Text="EP"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModEP" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModEPDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNCheckBox ID="chkModMT" runat="server" Text="MT"></rfn:RFNCheckBox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModMT" Width="70px" runat="server" TipoDato="Moneda" Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModMTDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <label id="lblModTot" runat="server" for="txtModTot" class="lblEtiquetasPadd">Total</label>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModTot" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModTotDescuento" Width="70px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False"></rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <label id="lblModHorTec" runat="server" for="txtModHorTecDescuento" class="lblEtiquetasPadd">Horas Téc</label>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModHorTec" Width="50px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModHorTecDescuento" Width="50px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False"></rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalCercano">
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <label id="lblModHorMed" runat="server" for="txtModHorMedDescuento" class="lblEtiquetasPadd">Horas Méd</label>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                                    <rfn:RFNTextbox ID="txtModHorMed" Width="50px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <rfn:RFNTextbox ID="txtModHorMedDescuento" Width="50px" runat="server" TipoDato="Moneda"
                                                                        Enabled="False"></rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                                --%><%--                                                        </div>--%>
                                                            </fieldset>
                                                            <div id="divLeyendaColore2" class="subelementosSeccionPrincipalPadd2">
                                                                <div class="elementosSeccionPrincipalCercano">
                                                                    <br />
                                                                    <label id="RFNLabel9" runat="server">_.</label>
                                                                    <label id="RFNLabel10" runat="server">El precio de la MT es el sumatorio de la Subscripción a Hospital Digital y la vigilancia de la salud colectiva</label>
                                                                </div>
                                                            </div>
                                                            <%--</div>--%>
                                                            <%--     </div>--%>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </rfn:RFNPanel>
                                </div>
                                <div id="divOcultarapProductos" runat="server" style="display: none;">
                                    <rfn:RFNPanel ID="apProductos" runat="server" EstiloContenedor="False" Titulo="Productos"
                                        Visualizacion="Seccion" Collapsable="False" Collapsed="False" Width="100%" Display="table">
                                        <asp:UpdatePanel ID="upProductos" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                            <ContentTemplate>
                                                <fieldset id="fsTarificacionProductos" class="seccionesPrincipales3">
                                                    <legend>
                                                        <label id="lblLegendTarificacionProductos" runat="server" class="seccionesPrincipales3" style="background-color: Red; color: Red; font-weight: bold; width: 100%; display: table; display: none;">Productos</label>
                                                    </legend>

                                                    <div runat="server" id="dvlineaproducto">
                                                        <label id="lbllineaproducto" runat="server" for="ddllineaproducto" class="lblEtiquetas">Linea Producto</label>
                                                        <rfn:RFNDropDownList runat="server" ID="ddllineaproducto" ValidationGroup="vGuardaContrato"
                                                            ErrorMessage="Debe informar la linea de producto" OnClientChange="ComprobarLP"
                                                            CausesValidation="False" DataValueField="COD_VALOR"
                                                            DataTextField="DES_VALOR"
                                                            Width="250px" PermitirVacio="true" Requerido="False" Enabled="False" CssClass="control_ddl">
                                                        </rfn:RFNDropDownList>
                                                    </div>

                                                    <div id="tarifaProductos" class="subelementosSeccionPrincipalPadd">
                                                        <label id="lblccdTarifaProductos" runat="server" for="ccdTarifaProductos" class="lblEtiquetas">Tarifa</label>
                                                        <rfn:RFNCodDescripcion ID="ccdTarifaProductos" runat="server" Width="600px" CampoCodigo="COD_TIP_TAR"
                                                            CampoDescripcion="DES_TIP_TAR" FuenteDatos="SPA.Starifas_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                            Titulo="Tarifas Productos" WidthCod="75px" Tipo="Procedimiento" NumElementos="50"
                                                            TipoCodigo="Numerico" Proxy="wsControlesContratacion" Requerido="False">
                                                            <Columnas>
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="ID_TIP_TARIF" DataField="ID_TIP_TARIF"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_CENTRAL" DataField="IND_CENTRAL"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ADMIN" DataField="IND_ADMIN"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRPROV" DataField="IND_DIRPROV"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRTER" DataField="IND_DIRTER"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIROFI" DataField="IND_DIROFI"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                            </Columnas>
                                                        </rfn:RFNCodDescripcion>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipalPadd" style="display: none">
                                                        <div class="elementosSeccionPrincipal">
                                                            <rfn:RFNCheckBox ID="chkProductoEspecialMedicina" runat="server" Text="Servicios Médicos incluidos"
                                                                Enabled="False"></rfn:RFNCheckBox>
                                                        </div>
                                                    </div>

                                                    <div id="mostrarProductos" class="subelementosSeccionPrincipalGrid" style="display: none">
                                                        <div class="subelementosSeccionPrincipalPadd">
                                                            <div class="elementosSeccionPrincipal">
                                                                <div class="subelementosSeccionPrincipalPaddProducto">
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <label id="lblVacio" runat="server" class="lblEtiquetas" style="color: White">lblVacio</label>
                                                                        <label id="lblPrecioTecnicoProducto" runat="server" class="lblEtiquetas" style="width: 50px">Técnico</label>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <label id="lblPrecioProducto" runat="server" class="lblEtiquetas">Precio</label>
                                                                        <rfn:RFNTextbox ID="txtPrecioTecnicoProducto" runat="server" TipoDato="DecimalPositivo"
                                                                            Width="75px" Enabled="False" Text="0" />
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <label id="lblHorasProducto" runat="server" class="lblEtiquetas" style="width: 50px; pointer-events: none; opacity: 0.6">Médico</label>
                                                                        <rfn:RFNTextbox ID="txtHorasTecnicoProducto" runat="server" TipoDato="DecimalPositivo"
                                                                            Width="75px" Enabled="False" Text="0" />
                                                                    </div>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPaddProducto">
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <label id="lblPrecioMedicoProducto" runat="server" style="width: 50px">Médico</label>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <rfn:RFNTextbox ID="txtPrecioMedicoProducto" runat="server" TipoDato="DecimalPositivo"
                                                                            Width="75px" Enabled="False" Text="0" />
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <rfn:RFNTextbox ID="txtHorasMedicoProducto" runat="server" TipoDato="DecimalPositivo"
                                                                            Width="75px" Enabled="False" Text="0" />
                                                                    </div>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPaddProducto">
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <label id="lblPrecioTotalProducto" runat="server" style="font-weight: bold; width: 50px">Total</label>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalProducto">
                                                                        <rfn:RFNTextbox ID="txtPrecioTotalProducto" runat="server" TipoDato="DecimalPositivo"
                                                                            Width="75px" Enabled="False" Font-Bold="True" Text="0" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPadd">
                                                            <rfn:RFNGridEditable2 ID="gvProducto" runat="server" GridLines="Both" CallBackFunction="manejadorGridProductos"
                                                                Width="895px" wsProxy="wsControlesContratacion" wsProxyMetodo="AccionesGridProductosContrato" AutoLoad="False"
                                                                Font-Size="X-Small">
                                                                <Configs>
                                                                    <rfn:ConfigGE KeyNames="COD_PRODUCTO, DES_PRODUCTO, DES_PRODUCTO_IMPRESION, ID_IDIOMA, COD_ACT_GENERAL, COD_TIPO_DATO_ESP, NUM_ESPECIFICA, IND_CENTRAL, IND_FACT_RECO, IND_FACT_ANALITICA, IND_FACT_HIGIENE, IND_FACT_CURSOS, COD_TIPO_PAGO, PORCENTAJE_SHE, PORCENTAJE_MT, IMP_PRECIO_FIJO, IMP_PRECIO_VAR, CAN_HORAS_FIJO, CAN_HORAS_VAR, CAN_TRAB_MIN, CAN_TRAB_MAX, IND_AUTONOMO, NOM_USUARIO_ALTA, 
                                                                                NOM_USUARIO_BAJA, FEC_ALTA, FEC_BAJA, COD_ACT_TRAB, COD_ENTIDPRO, DES_OBSERVACIONES, IND_MULTIEMPRESA, IND_AREA, FACTOR_CORRECTOR, IND_DEFECTO, IND_TIPO_CURSO, COD_CURSO_AE_EXTRANET, ID_PRODUCTO, COD_EMPPRL, COD_MONEDA, CAN_PRODUCTOS, CAN_ENTIDADES_PROD, CAN_HORAS_SHE, CAN_HORAS_MT, IMP_SHE, IMP_MT, CAN_HORAS_TOTAL, IMP_PRODUCTO "
                                                                        EnableAddRow="False" EnableDeleteRow="True" EnableEditRow="False" PosActionButtons="BOTH">
                                                                        <Columnas>
                                                                            <rfn:RFNLabelBound2 DataField="S_NUM_ESPECIFICA" HeaderText="Num.Curso" Width="10%" />
                                                                            <rfn:RFNLabelBound2 DataField="COD_PRODUCTO" HeaderText="Cod.Producto" Width="10%" />
                                                                            <rfn:RFNLabelBound2 DataField="DES_PRODUCTO" HeaderText="Producto" Width="40%" />
                                                                            <rfn:RFNLabelBound2 DataField="ID_PRODUCTO" HeaderText="ID_PRODUCTO" Visible="False" />
                                                                            <rfn:RFNLabelBound2 DataField="IMP_PRODUCTO" HeaderText="Coste Total" Width="10%" />
                                                                            <rfn:RFNLabelBound2 DataField="CAN_HORAS_TOTAL" HeaderText="Horas Contrato" Width="10%" />
                                                                            <rfn:RFNLabelBound2 DataField="PRECIO_BASE" HeaderText="Precio Base" />
                                                                            <rfn:RFNLabelBound2 DataField="CAN_PRODUCTOS" HeaderText="Nº.Productos." Width="10px" />
                                                                            <rfn:RFNLabelBound2 DataField="IND_MULTIEMPRESA" HeaderText="Multiempresa" Width="10px" />
                                                                            <rfn:RFNLabelBound2 DataField="DES_AREA" HeaderText="Área" Width="10px" />
                                                                            <rfn:RFNLabelBound2 DataField="IND_TIPO_CURSO" HeaderText="Tipo Curso" Width="10px" />
                                                                            <rfn:RFNLabelBound2 DataField="CAN_ENTIDADES_PROD" HeaderText="Nº Unid" Width="10px" />
                                                                            <rfn:RFNLabelBound2 DataField="DES_ENTIDPRO" HeaderText="Unidad" Width="10px" />
                                                                        </Columnas>
                                                                    </rfn:ConfigGE>
                                                                </Configs>
                                                            </rfn:RFNGridEditable2>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </rfn:RFNPanel>
                                </div>
                                <div id="divOcultarapAutonomos" runat="server" style="display: none;">
                                    <rfn:RFNPanel ID="apAutonomos" runat="server" EstiloContenedor="False" Titulo="Autónomos"
                                        Visualizacion="Seccion" Collapsable="False" Collapsed="False" Width="100%" Display="table">
                                        <asp:UpdatePanel ID="upAutonomos" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                            <ContentTemplate>
                                                <fieldset id="fsTarificacionAutonomos" class="seccionesPrincipales3">
                                                    <legend>
                                                        <label id="lblLegendTarificacionAutonomos" runat="server">Autónomos</label>
                                                    </legend>
                                                    <div id="tarifaAutonomos" class="subelementosSeccionPrincipalPadd">
                                                        <label id="lblccdTarifaAutonomos" runat="server" for="ccdTarifaAutonomos" class="lblEtiquetas">Tarifa</label>
                                                        <rfn:RFNCodDescripcion ID="ccdTarifaAutonomos" runat="server" Width="600px" CampoCodigo="COD_TIP_TAR"
                                                            CampoDescripcion="DES_TIP_TAR" FuenteDatos="SPA.Starifas_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                            Titulo="Tarifas Autónomos" WidthCod="75px" Tipo="Procedimiento" NumElementos="50"
                                                            TipoCodigo="Numerico" Proxy="wsControlesContratacion" Requerido="False" Enabled="True">
                                                            <Columnas>
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="ID_TIP_TARIF" DataField="ID_TIP_TARIF"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_CENTRAL" DataField="IND_CENTRAL"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ADMIN" DataField="IND_ADMIN"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRPROV" DataField="IND_DIRPROV"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRTER" DataField="IND_DIRTER"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIROFI" DataField="IND_DIROFI"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                            </Columnas>
                                                        </rfn:RFNCodDescripcion>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipalPadd">
                                                        <div class="subelementosSeccionPrincipalPaddProducto">
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblVacioAutonomo" runat="server" class="lblEtiquetas" style="color: White">lblVacio</label>
                                                                <label id="lblPrecioTecnicoProductoAutonomo" runat="server" style="width: 50px">Técnico</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblPrecioProductoAutonomo" runat="server" class="lblEtiquetas">Precio</label>
                                                                <rfn:RFNTextbox ID="txtPrecioTecnicoProductoAutonomo" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblHorasProductoAutonomo" runat="server" class="lblEtiquetas">Horas</label>
                                                                <rfn:RFNTextbox ID="txtHorasTecnicoProductoAutonomo" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddProducto">
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblPrecioMedicoProductoAutonomo" runat="server" style="width: 50px;">Medico</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <rfn:RFNTextbox ID="txtPrecioMedicoProductoAutonomo" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <rfn:RFNTextbox ID="txtHorasMedicoProductoAutonomo" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddProducto">
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblPrecioTotalProductoAutonomo" runat="server" style="font-weight: bold; width: 50px">Total</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <rfn:RFNTextbox ID="txtPrecioTotalProductoAutonomo" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Font-Bold="True" Text="0" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipalGrid">
                                                        <rfn:RFNGridEditable2 ID="gvProductoAutonomo" runat="server" GridLines="Both" CssClass="borde_grid"
                                                            CallBackFunction="manejadorGridProductosAutonomos" Width="895px" wsProxy="wsControlesContratacion"
                                                            wsProxyMetodo="AccionesGridProductosAutonomoContrato" AutoLoad="False">
                                                            <Configs>
                                                                <rfn:ConfigGE KeyNames="COD_PRODUCTO, DES_PRODUCTO, DES_PRODUCTO_IMPRESION, ID_IDIOMA, COD_ACT_GENERAL, COD_TIPO_DATO_ESP, NUM_ESPECIFICA, IND_CENTRAL, IND_FACT_RECO, IND_FACT_ANALITICA, IND_FACT_HIGIENE, IND_FACT_CURSOS, COD_TIPO_PAGO, PORCENTAJE_SHE, PORCENTAJE_MT, IMP_PRECIO_FIJO, IMP_PRECIO_VAR, CAN_HORAS_FIJO, CAN_HORAS_VAR, CAN_TRAB_MIN, CAN_TRAB_MAX, IND_AUTONOMO, NOM_USUARIO_ALTA, 
                                                                                NOM_USUARIO_BAJA, FEC_ALTA, FEC_BAJA, COD_ACT_TRAB, COD_ENTIDPRO, DES_OBSERVACIONES, IND_MULTIEMPRESA, IND_AREA, FACTOR_CORRECTOR, IND_DEFECTO, IND_TIPO_CURSO, COD_CURSO_AE_EXTRANET, ID_PRODUCTO, COD_EMPPRL, COD_MONEDA, CAN_PRODUCTOS, CAN_ENTIDADES_PROD, CAN_HORAS_SHE, CAN_HORAS_MT, IMP_SHE, IMP_MT, CAN_HORAS_TOTAL, IMP_PRODUCTO "
                                                                    EnableAddRow="False" EnableDeleteRow="True" EnableEditRow="False" PosActionButtons="BOTH">
                                                                    <Columnas>
                                                                        <rfn:RFNLabelBound2 DataField="S_NUM_ESPECIFICA" HeaderText="Num.Curso" Width="10%" />
                                                                        <rfn:RFNLabelBound2 DataField="COD_PRODUCTO" HeaderText="Cod.Producto" Width="10%" />
                                                                        <rfn:RFNLabelBound2 DataField="DES_PRODUCTO" HeaderText="Producto" Width="40%" />
                                                                        <rfn:RFNLabelBound2 DataField="ID_PRODUCTO" HeaderText="ID_PRODUCTO" Visible="False" />
                                                                        <rfn:RFNLabelBound2 DataField="IMP_PRODUCTO" HeaderText="Coste Total" Width="10%" />
                                                                        <rfn:RFNLabelBound2 DataField="CAN_HORAS_TOTAL" HeaderText="Horas Contrato" Width="10%" />
                                                                        <rfn:RFNLabelBound2 DataField="PRECIO_BASE" HeaderText="Precio Base" />
                                                                        <rfn:RFNLabelBound2 DataField="CAN_PRODUCTOS" HeaderText="Nº.Productos." Width="10px" />
                                                                        <rfn:RFNLabelBound2 DataField="IND_MULTIEMPRESA" HeaderText="Multiempresa" Width="10px" />
                                                                        <rfn:RFNLabelBound2 DataField="DES_AREA" HeaderText="Área" Width="10px" />
                                                                        <rfn:RFNLabelBound2 DataField="IND_TIPO_CURSO" HeaderText="Tipo Curso" Width="10px" />
                                                                    </Columnas>
                                                                </rfn:ConfigGE>
                                                            </Configs>
                                                        </rfn:RFNGridEditable2>
                                                    </div>
                                                </fieldset>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </rfn:RFNPanel>
                                </div>
                                <div id="divOcultarapBolsaHoras" runat="server" style="display: none;">
                                    <rfn:RFNPanel ID="apBolsaHoras" runat="server" EstiloContenedor="False" Titulo="Bolsa de Horas"
                                        Visualizacion="Seccion" Collapsable="False" Collapsed="False" Width="100%" Display="table">
                                        <asp:UpdatePanel ID="upBolsaHoras" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                            <ContentTemplate>
                                                <fieldset id="fsTarificacionBolsaHoras" class="seccionesPrincipales3">
                                                    <legend>
                                                        <label id="lblLegendTarificacionBolsaHoras" runat="server">Bolsa de Horas</label>
                                                    </legend>
                                                    <div id="tarifaBolsaHoras" class="subelementosSeccionPrincipalPadd">
                                                        <label id="lblccdTarifaBolsaHoras" runat="server" for="ccdTarifaBolsaHoras" class="lblEtiquetas">Tarifa</label>
                                                        <rfn:RFNCodDescripcion ID="ccdTarifaBolsaHoras" runat="server" Width="600px" CampoCodigo="COD_TIP_TAR"
                                                            CampoDescripcion="DES_TIP_TAR" FuenteDatos="SPA.Starifas_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                            Titulo="Tarifas Bolsa de Horas" WidthCod="75px" Tipo="Procedimiento" NumElementos="50"
                                                            TipoCodigo="Numerico" Proxy="wsControlesContratacion" Requerido="False">
                                                            <Columnas>
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="ID_TIP_TARIF" DataField="ID_TIP_TARIF"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_CENTRAL" DataField="IND_CENTRAL"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_ADMIN" DataField="IND_ADMIN"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRPROV" DataField="IND_DIRPROV"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIRTER" DataField="IND_DIRTER"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                                <rfn:ColumnaCodDescripcion InfoExtra="True" HeaderText="IND_DIROFI" DataField="IND_DIROFI"
                                                                    MostrarEnGrid="false" MostrarEnDescripcion="False" />
                                                            </Columnas>
                                                        </rfn:RFNCodDescripcion>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipalPadd">
                                                        <div class="subelementosSeccionPrincipalPaddProducto">
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblVacioBolsaHoras" runat="server" class="lblEtiquetas" style="color: White">lblVacio</label>
                                                                <label id="lblPrecioTecnicoProductoBolsaHoras" runat="server" style="width: 50px">Técnico</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblPrecioProductoBolsaHoras" runat="server" class="lblEtiquetas">Precio</label>
                                                                <rfn:RFNTextbox ID="txtPrecioTecnicoProductoBolsaHoras" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblHorasProductoBolsaHoras" runat="server" class="lblEtiquetas">Horas</label>
                                                                <rfn:RFNTextbox ID="txtHorasTecnicoProductoBolsaHoras" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddProducto">
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblPrecioMedicoProductoBolsaHoras" runat="server" style="width: 50px">Médico</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <rfn:RFNTextbox ID="txtPrecioMedicoProductoBolsaHoras" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <rfn:RFNTextbox ID="txtHorasMedicoProductoBolsaHoras" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Text="0" />
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipalPaddProducto">
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <label id="lblPrecioTotalProductoBolsaHoras" runat="server" style="font-weight: bold; width: 50px">Total</label>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalProducto">
                                                                <rfn:RFNTextbox ID="txtPrecioTotalProductoBolsaHoras" runat="server" TipoDato="DecimalPositivo"
                                                                    Width="75px" Enabled="False" Font-Bold="True" Text="0" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipalGrid">
                                                        <rfn:RFNGridEditable2 ID="gvProductoBolsaHoras" runat="server" GridLines="Both" CssClass="borde_grid"
                                                            CallBackFunction="manejadorGridProductosBolsaHoras" Width="895px" wsProxy="wsControlesContratacion"
                                                            wsProxyMetodo="AccionesGridProductosBolsaHorasContrato" AutoLoad="False">
                                                            <Configs>
                                                                <rfn:ConfigGE KeyNames="COD_PRODUCTO, DES_PRODUCTO, DES_PRODUCTO_IMPRESION, ID_IDIOMA, COD_ACT_GENERAL, COD_TIPO_DATO_ESP, NUM_ESPECIFICA, IND_CENTRAL, IND_FACT_RECO, IND_FACT_ANALITICA, IND_FACT_HIGIENE, IND_FACT_CURSOS, COD_TIPO_PAGO, PORCENTAJE_SHE, PORCENTAJE_MT, IMP_PRECIO_FIJO, IMP_PRECIO_VAR, CAN_HORAS_FIJO, CAN_HORAS_VAR, CAN_TRAB_MIN, CAN_TRAB_MAX, IND_AUTONOMO, NOM_USUARIO_ALTA, 
                                                                                NOM_USUARIO_BAJA, FEC_ALTA, FEC_BAJA, COD_ACT_TRAB, COD_ENTIDPRO, DES_OBSERVACIONES, IND_MULTIEMPRESA, IND_AREA, FACTOR_CORRECTOR, IND_DEFECTO, IND_TIPO_CURSO, COD_CURSO_AE_EXTRANET, ID_PRODUCTO, COD_EMPPRL, COD_MONEDA, CAN_PRODUCTOS, CAN_ENTIDADES_PROD, CAN_HORAS_SHE, CAN_HORAS_MT, IMP_SHE, IMP_MT, CAN_HORAS_TOTAL, IMP_PRODUCTO "
                                                                    EnableAddRow="False" EnableDeleteRow="True" EnableEditRow="False" PosActionButtons="BOTH">
                                                                    <Columnas>
                                                                        <rfn:RFNLabelBound2 DataField="S_NUM_ESPECIFICA" HeaderText="Num.Curso" Width="10%"
                                                                            Visible="False" />
                                                                        <rfn:RFNLabelBound2 DataField="COD_PRODUCTO" HeaderText="Cod.Producto" Width="10%" />
                                                                        <rfn:RFNLabelBound2 DataField="DES_PRODUCTO" HeaderText="Producto" Width="40%" />
                                                                        <rfn:RFNLabelBound2 DataField="ID_PRODUCTO" HeaderText="ID_PRODUCTO" Visible="False" />
                                                                        <rfn:RfnTextBoxBound2 DataField="IMP_PRODUCTO" HeaderText="Coste Total" Width="30%"
                                                                            Editable="True" MinValue="0" TipoDato="DecimalPositivo" />
                                                                        <rfn:RfnTextBoxBound2 DataField="CAN_HORAS_TOTAL" HeaderText="Horas Contrato" Width="60%"
                                                                            Editable="True" MinValue="0" TipoDato="DecimalPositivo" />
                                                                        <rfn:RFNLabelBound2 DataField="PRECIO_BASE" HeaderText="Precio Base" />
                                                                        <rfn:RFNLabelBound2 DataField="CAN_PRODUCTOS" HeaderText="Nº.Productos." Width="10px"
                                                                            Visible="False" />
                                                                        <rfn:RFNLabelBound2 DataField="IND_MULTIEMPRESA" HeaderText="Multiempresa" Width="10px"
                                                                            Visible="False" />
                                                                        <rfn:RFNLabelBound2 DataField="DES_AREA" HeaderText="Área" Width="10px" />
                                                                        <rfn:RFNLabelBound2 DataField="IND_TIPO_CURSO" HeaderText="Tipo Curso" Width="10px" />
                                                                    </Columnas>
                                                                </rfn:ConfigGE>
                                                            </Configs>
                                                        </rfn:RFNGridEditable2>
                                                    </div>
                                                </fieldset>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </rfn:RFNPanel>
                                </div>
                                <div id="divOcultarFactRecos" runat="server" style="display: block;">
                                    <fieldset id="fsFactRecos" class="seccionesPrincipales4">
                                        <legend>
                                            <label id="lblFieldSetFactRecos" runat="server">Facturación de Reconocimientos</label>
                                        </legend>
                                        <div class="subelementosSeccionPrincipal">
                                            <div class="elementosSeccionPrincipalCercano">
                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                    <label id="lblImporteTarifaReco" runat="server">Importe según Tarifa: </label>
                                                </div>
                                                <div class="subelementosSeccionPrincipal">
                                                    <label id="lblImporteTarifaRecoDescuento" runat="server">Importe aplicado:</label>
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <div class="subelementosSeccionPrincipal">
                                                    <label id="lblBajaPeligrosidad" runat="server" for="txtBajaPeligrosidad" class="lblEtiquetas">Bajo Riesgo</label>
                                                </div>
                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                    <rfn:RFNTextbox ID="txtAntBajaPeligrosidad" Width="100px" runat="server" TipoDato="Moneda"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="subelementosSeccionPrincipal">
                                                    <rfn:RFNTextbox ID="txtBajaPeligrosidad" Width="100px" runat="server" TipoDato="Moneda"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <div class="subelementosSeccionPrincipal">
                                                    <label id="lblAltaPeligrosidad" runat="server" for="txtAltaPeligrosidad" class="lblEtiquetas">Alto Riesgo</label>
                                                </div>
                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                    <rfn:RFNTextbox ID="txtAntAltaPeligrosidad" Width="100px" runat="server" TipoDato="Moneda"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="subelementosSeccionPrincipal">
                                                    <rfn:RFNTextbox ID="txtAltaPeligrosidad" Width="100px" runat="server" TipoDato="Moneda"
                                                        Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <div class="subelementosSeccionPrincipal">
                                                    <label id="lblIncluyeRecos" runat="server" for="txtIncluyeRecos" class="lblEtiquetas">Incluye</label>
                                                </div>
                                                <div class="subelementosSeccionPrincipal" style="display: none">
                                                    <rfn:RFNTextbox ID="txtAntIncluyeRecos" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                        MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                                <div class="subelementosSeccionPrincipal">
                                                    <rfn:RFNTextbox ID="txtIncluyeRecos" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                        MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <div class="subelementosSeccionPrincipal">
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <div class="subelementosSeccionPrincipal">
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano" id="reconocimientosPreFacturados">
                                                <div class="subelementosSeccionPrincipal">
                                                    <rfn:RFNCheckBox ID="chkModRPF" runat="server" Text="RPF" Style="display: none"></rfn:RFNCheckBox>
                                                    <label id="lblReconocimientosPrefacturados" runat="server" for="txtModRPF" class="lblEtiquetas">Importe Reconocimientos Prefact.</label>
                                                </div>
                                                <div class="subelementosSeccionPrincipal">
                                                    <rfn:RFNTextbox ID="txtModRPF" Width="80px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="subelementosSeccionPrincipal">
                                            <div class="elementosSeccionPrincipalCercano">
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <rfn:RFNTextbox ID="txtDescRecoBaja" Width="40px" runat="server" TipoDato="DecimalPositivo"
                                                    MaxLength="6" Enabled="False" ViewStateMode="Enabled" MaxValue="100"></rfn:RFNTextbox>
                                                <label id="lblDescRecoBaja" runat="server" for="txtDescRecoBaja">%Desc.Reco.Bajo Riesgo</label>
                                            </div>
                                            <div class="elementosSeccionPrincipalCercano">
                                                <rfn:RFNTextbox ID="txtDescRecoAlta" Width="40px" runat="server" TipoDato="DecimalPositivo"
                                                    MaxLength="6" Enabled="False" ViewStateMode="Enabled" MaxValue="100"></rfn:RFNTextbox>
                                                <label id="lblDescRecoAlta" runat="server" for="txtDescRecoAlta">%Desc.Reco.Alto Riesgo</label>
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                            </rfn:RFNPanel>


                            <rfn:RFNPanel ID="grupoFacturacion" runat="server" EstiloContenedor="False" Titulo="Facturación"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <fieldset id="fsFacturacion" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendFacturacion" runat="server">Facturación</label>
                                    </legend>
                                    <asp:UpdatePanel ID="upfacturacion" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                        <ContentTemplate>
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <fieldset id="fsCtrIndicadores" class="seccionesPrincipales3">
                                                    <legend>
                                                        <label id="lblLegendCtrIndicadores" runat="server" for="txtRefFact" class="lblEtiquetas" style="font-weight: False; width: 75px; pointer-events: none; opacity: 0.6: True; display: none">Indicadores</label>
                                                    </legend>
                                                    <div class="subelementosSeccionPrincipalPadd">
                                                        <div class="elementosSeccionPrincipalCercano">
                                                            <br />
                                                            <rfn:RFNCheckBox ID="chkIndIPC" runat="server" Text="Aplicar IPC desde:" Font-Bold="False"
                                                                OnClientClick="cambioChkIndIPC"></rfn:RFNCheckBox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <br />
                                                            <rfn:RFNCalendar ID="calIPCDesde" runat="server" ValidationGroup="vGuardaContrato"
                                                                ErrorMessage="Error en Fecha IPC" Width="75px" Enabled="True"></rfn:RFNCalendar>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <br />
                                                            <rfn:RFNCheckBox ID="chkRecordatorioIPC" runat="server" Text="Recordatorio IPC"></rfn:RFNCheckBox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalCercano">
                                                            <rfn:RFNCheckBox ID="chkCarteraNegociada" runat="server" Text="Cartera Negociada  -  Inicio Facturación:"
                                                                Font-Bold="False" OnClientClick="cambiochkCarteraNegociada"></rfn:RFNCheckBox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal" style="display: none">
                                                            <rfn:RFNCalendar ID="calFecIniFact" runat="server" Width="75px" Enabled="True" CausesValidation="True"
                                                                ValidationGroup="vGuardaContrato" ErrorMessage="Error en Fecha Inicio Facturación de Cartera Negociada"></rfn:RFNCalendar>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal" style="display: none">
                                                            <label id="lblRefFact" runat="server" for="txtRefFact" class="lblEtiquetas">Ref. Factura</label>
                                                            <rfn:RFNTextbox ID="txtRefFact" Width="150px" runat="server" MaxLength="20" TipoDato="Texto" OnClientChange="COPIADATO1"></rfn:RFNTextbox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipalCercano" style="display: block">
                                                            <label id="lblNumpedidoF" runat="server" for="txtNumPedidoF" class="lblEtiquetas">Nº Pedido Fijo</label>
                                                            <rfn:RFNTextbox ID="txtNumPedidoF" Width="150px" runat="server" MaxLength="20" TipoDato="Texto" OnClientChange="COPIADATO1"></rfn:RFNTextbox>

                                                        </div>

                                                        <div class="elementosSeccionPrincipalCercano" style="display: block">
                                                            <label id="lblNumpedidoV" runat="server" for="txtNumPedidoV" class="lblEtiquetas">Nº Pedido Variable</label>
                                                            <rfn:RFNTextbox ID="txtNumPedidoV" Width="150px" runat="server" MaxLength="20" TipoDato="Texto" OnClientChange="COPIADATO3"></rfn:RFNTextbox>

                                                        </div>


                                                    </div>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalPop">
                                                            <rfn:RFNCheckBox ID="chkFactPorCentro" runat="server" Text="Facturación por Centro"
                                                                Font-Bold="False" OnClientClick="cambioChkPorCent"></rfn:RFNCheckBox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalPop">
                                                            <rfn:RFNImage ID="imgDetalleFactCentro" runat="server" ImageUrl="~/Recursos/Imagenes/Detalle.png"></rfn:RFNImage>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <div id="PanelPopExFactCentros" class="popupControl" style="display: none">
                                                                <div class="control_derecha">
                                                                    <rfn:RFNImage ID="imgCierrepopUpCentros" runat="server" />
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPadd">
                                                                    <div class="elementosSeccionPrincipalCent">
                                                                        <rfn:RFNCheckBox ID="chkFactModCent" runat="server" Text="Facturar Modalidades por Centro de Trabajo desde:"
                                                                            Font-Bold="False" OnClientClick="cambioChkFactModCent"></rfn:RFNCheckBox>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipal">
                                                                        <rfn:RFNCalendar ID="calFecFactModCentDesde" runat="server" Width="75px" Enabled="False"
                                                                            CausesValidation="True" ValidationGroup="vGuardaContrato"
                                                                            ErrorMessage="Fecha Facturar Modalidades por Centro Obligatoria"></rfn:RFNCalendar>
                                                                    </div>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPadd" style="display: none">
                                                                    <div class="elementosSeccionPrincipalCent">
                                                                        <rfn:RFNCheckBox ID="chkFactActHigCent" runat="server" Text="Facturar Actividades Higiénicas por Centro de Trabajo desde:"
                                                                            Font-Bold="False" OnClientClick="cambioChkFactActHigCent"></rfn:RFNCheckBox>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipal">
                                                                        <rfn:RFNCalendar ID="calFecFactActHigCentDesde" runat="server" Width="75px" Enabled="False"
                                                                            ValidationGroup="vGuardaContrato" CausesValidation="True"
                                                                            ErrorMessage="Fecha Facturar Higiene Obligatoria"></rfn:RFNCalendar>
                                                                    </div>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPadd">
                                                                    <div class="elementosSeccionPrincipalCent">
                                                                        <rfn:RFNCheckBox ID="chkFactRecMedCent" runat="server" Text="Facturar Reconocimientos Médicos y otras Pruebas VSI por Centro de Trabajo desde:"
                                                                            Font-Bold="False" OnClientClick="cambioChkFactRecMedCent"></rfn:RFNCheckBox>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipal">
                                                                        <rfn:RFNCalendar ID="calFecFactRecMedCentDesde" runat="server" Width="75px" Enabled="False"
                                                                            ValidationGroup="vGuardaContrato" CausesValidation="True"
                                                                            ErrorMessage="Fecha Facturar Reconocimientos Médicos por Centro Obligatoria"></rfn:RFNCalendar>
                                                                    </div>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPadd">
                                                                    <div class="elementosSeccionPrincipalCent">
                                                                        <rfn:RFNCheckBox ID="chkFactAnalCent" runat="server" Text="Facturar Analíticas por Centro de Trabajo desde:"
                                                                            Font-Bold="False" OnClientClick="cambioChkFactAnalCent"></rfn:RFNCheckBox>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipal">
                                                                        <rfn:RFNCalendar ID="calFecFactAnalCentDesde" runat="server" Width="75px" Enabled="False"
                                                                            ErrorMessage="Fecha Facturar Analíticas por Centro Obligatoria"
                                                                            CausesValidation="True" ValidationGroup="vGuardaContrato"></rfn:RFNCalendar>
                                                                    </div>
                                                                </div>
                                                                <div class="subelementosSeccionPrincipalPadd">
                                                                    <rfn:RFNCheckBox ID="chkEnvCentro" runat="server" Text="Enviar facturas al Centro"
                                                                        Font-Bold="False" OnClientClick="cambioEnvCent"></rfn:RFNCheckBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal" style="display: none;">
                                                            <rfn:RFNCheckBox ID="chkFactLibre" runat="server" Text="Facturación Libre" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal">
                                                            <rfn:RFNCheckBox ID="chkFactElectronica" runat="server" Text="Envío de facturas por Email"
                                                                Font-Bold="False" OnClientClick="cambiochkFactElectronica"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal">
                                                            <rfn:RFNCheckBox ID="chkFactPeriodoVenc" runat="server" Text="Facturación Período Vencido"
                                                                Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>
                                                    </div>

                                                    <div class="subelementosSeccionPrincipal">
                                                        <%--dvv facturacion libre F y V y retencion pdf F y V--%>
                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkFactLibreF" runat="server" Text="Fact. Libre Parte Fija" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkFLrec" runat="server" Text="Fact. Libre Reconocimientos" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkFLana" runat="server" Text="Fact. Libre Analiticas" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkFLvsi" runat="server" Text="Fact. Libre otras VSI" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: none;">
                                                            <rfn:RFNCheckBox ID="chkFactLibreV" runat="server" Text="Facturación Libre Parte Variable" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: none;">
                                                            <rfn:RFNCheckBox ID="chkRetPdfF" runat="server" Text="Retecion PDF Parte Fija" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: none;">
                                                            <rfn:RFNCheckBox ID="chkRetPdfV" runat="server" Text="Retecion PDF Parte Variable" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>




                                                        <div id="formacionBonificada" class="elementosSeccionPrincipal" style="display: none">
                                                            <rfn:RFNCheckBox ID="chkFormBonif" runat="server" Text="Formación bonificada" Font-Bold="False"
                                                                OnClientClick="cambioChkFormBonificada"></rfn:RFNCheckBox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <rfn:RFNCheckBox ID="chkFact_U_DESGL" runat="server" Text="Facturación Única Desglosada" Style="display: none" Font-Bold="False"></rfn:RFNCheckBox>
                                                        </div>

                                                    </div>

                                                    <div class="subelementosSeccionPrincipal">

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkFactUniVsi" runat="server" Text="Fact. Unica VSI." Font-Bold="False"></rfn:RFNCheckBox>

                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkFactAnal" runat="server" Text="Fact. Analít." BorderStyle="None"
                                                                Enabled="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkfactRecos" runat="server" Text="Fact. Recos." Checked="True"
                                                                Enabled="False"></rfn:RFNCheckBox>
                                                        </div>

                                                        <div class="elementosSeccionPrincipal" style="display: block;">
                                                            <rfn:RFNCheckBox ID="chkCancenlacionUM" runat="server" Text="Penalización cancelación UM"></rfn:RFNCheckBox>
                                                        </div>

                                                    </div>

                                                    <div id="camposQS" runat="server" style="display: none">

                                                        <rfn:RFNCheckBox ID="rfnchkpedido" runat="server" Text="Precisa Pedido" BorderStyle="None"
                                                            Checked="false" Enabled="true"></rfn:RFNCheckBox>

                                                        <rfn:RFNCheckBox ID="rfnchkcerrado" runat="server" Text="Precio Cerrado" Checked="false"
                                                            Enabled="true"></rfn:RFNCheckBox>

                                                    </div>

                                                    <%--  //dia de pago y cif pagador ocultos numero de pedido F y V--%>
                                                    <div class="subelementosSeccionPrincipal" style="display: block">
                                                        <div class="elementosSeccionPrincipalCercano">
                                                            <label id="lbldiapago" runat="server" for="txtdiapago" class="lblEtiquetas">Día de Pago</label>
                                                            <rfn:RFNTextbox ID="txtdiapago" Width="150px" runat="server" MaxLength="2" TipoDato="EnteroPositivo" OnClientChange="RevisarDia"></rfn:RFNTextbox>

                                                        </div>

                                                        <div runat="server" id="divActivarCifPagador" class="elementosSeccionPrincipalCercano" style="display: block">
                                                            <label id="lblcifpagador" runat="server" for="ccdCifPagador" class="lblEtiquetas">Otro Pagador</label>
                                                            <rfn:RFNCodDescripcion ID="ccdCifPagador" runat="server" Width="400px" CampoCodigo="COD_IDENTIFICADOR"
                                                                CampoDescripcion="DES_RAZON_SOCIAL" FuenteDatos="SPA.S_CLIENTES" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                                Titulo="Razón Social" WidthCod="75px" TipoCodigo="Alfanumerico" ValidationGroup="" OnClientChange="ComprobarCif"
                                                                Proxy="wsControlesContratacion" NumElementos="50" Tipo="Procedimiento" Enabled="True" MaxLengthCodigo="10">
                                                                <Columnas>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="ID_CLIENTE" HeaderText="ID. Cliente"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="true"
                                                                        DataField="IND_AUTONOMO" HeaderText="Autónomo"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="DES_RAZON_SOCIAL_PIPES"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="COD_TIPO_EMPRESA"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="NUM_CONTRATOS"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="NUM_PRESUPUESTOS"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="COD_EMPPRL"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="DES_EMAIL"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="ID_GRUPO"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="COD_TIPO_IDENTIF"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="ID_DOMICILIO_SOCI"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="IND_GRAN_EMPRESA"></rfn:ColumnaCodDescripcion>
                                                                    <rfn:ColumnaCodDescripcion InfoExtra="True" MostrarEnDescripcion="false" MostrarEnGrid="false"
                                                                        DataField="ID_ACTIVIDAD"></rfn:ColumnaCodDescripcion>
                                                                </Columnas>
                                                            </rfn:RFNCodDescripcion>





                                                        </div>

                                                        <%--  <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblNumpedidoF" runat="server" for="txtNumPedidoF" class="lblEtiquetas">Nº Pedido Fijo</label>
                                                    <rfn:RFNTextbox ID="txtNumPedidoF" Width="150px" runat="server"  TipoDato="EnteroPositivo"></rfn:RFNTextbox>

                                                </div>

                                                   <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblNumpedidoV" runat="server" for="txtNumPedidoV" class="lblEtiquetas">Nº Pedido Variable</label>
                                                    <rfn:RFNTextbox ID="txtNumPedidoV" Width="150px" runat="server"  TipoDato="EnteroPositivo"></rfn:RFNTextbox>

                                                </div>--%>
                                                    </div>



                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalCercano">
                                                            <label id="lblFormaPago" runat="server" for="rblTipoPago" class="lblEtiquetas">Forma de Pago</label>
                                                            <rfn:RFNRadioButtonList ID="rblTipoPago" runat="server" ErrorMessage="Forma de Pago Obligatoria"
                                                                ValidationGroup="vGuardaContrato" BorderWidth="1" BorderStyle="Solid" BorderColor="Black"
                                                                OnClientChange="cambioFormaPago" Width="300px" Requerido="True" CausesValidation="True">
                                                                <asp:ListItem Enabled="true" Text="Domiciliación" Value="D" Selected="true"></asp:ListItem>
                                                                <asp:ListItem Enabled="true" Text="Transferencia" Value="T"></asp:ListItem>
                                                            </rfn:RFNRadioButtonList>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblPeriPago" runat="server" for="rblPeriPago" class="lblEtiquetas">Periodo de Facturación</label>
                                                            <rfn:RFNRadioButtonList ID="rblPeriPago" runat="server" ErrorMessage="Periodo de Facturación Obligatorio"
                                                                ValidationGroup="vGuardaContrato" BorderWidth="1" BorderStyle="Solid" BorderColor="Black"
                                                                Width="300px" Requerido="True" CausesValidation="True" OnClientChange="cambioPeriPago">
                                                                <asp:ListItem Enabled="true" Text="Mensual" Value="M"></asp:ListItem>
                                                                <asp:ListItem Enabled="true" Text="Trimestral" Value="T"></asp:ListItem>
                                                                <asp:ListItem Enabled="true" Text="Semestral" Value="S"></asp:ListItem>
                                                                <asp:ListItem Enabled="true" Text="Anual" Value="A" Selected="true"></asp:ListItem>
                                                            </rfn:RFNRadioButtonList>
                                                        </div>
                                                        <div class="elementosSeccionPrincipal">
                                                            <label id="lblPlazoPago" runat="server" for="cmbPlazoPago" class="lblEtiquetas">Plazo de Pago</label>
                                                            <rfn:RFNDropDownList ID="cmbPlazoPago" runat="server" DataValueField="COD_VALOR"
                                                                DataTextField="DES_VALOR" PermitirVacio="True" Width="80px">
                                                            </rfn:RFNDropDownList>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <fieldset id="fsCtrDirEnvFact" class="seccionesPrincipales3">
                                                    <legend>
                                                        <label id="lblLegendCtrDirEnvFact" runat="server">Dirección de envío de facturas</label>
                                                    </legend>
                                                    <div id="dirEnvFact" class="mostrarControl">
                                                        <div class="subelementosSeccionPrincipal">
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblProvinciaEnvFact" runat="server" for="cmbProvinciaEnvFact" class="lblEtiquetas">Provincia</label>
                                                                <rfn:RFNDropDownList ID="cmbProvinciaEnvFact" runat="server" Width="192px" PermitirVacio="True"
                                                                    ErrorMessage="Error en Provincia de la Dirección de envío de facturas" ValidationGroup="vGuardaContrato" Requerido="False"
                                                                    DataTextField="DESCRIPCION" DataValueField="ID_REGION" OnClientChange="CambioProvinciaClienteEnvFact" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblPoblacionEnvFact" runat="server" for="ccdPoblacionEnvFact" class="lblEtiquetas">Población</label>
                                                                <rfn:RFNCodDescripcion ID="ccdPoblacionEnvFact" runat="server" FuenteDatos="SPA.Spoblaciones_Read"
                                                                    Width="300px" Requerido="False" ErrorMessage="Error en Población de la Dirección de envío de facturas" ValidationGroup="vGuardaContrato"
                                                                    BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Población" Tipo="Procedimiento" MostrarCodigo="False"
                                                                    CampoCodigo="ID_POBLACION" CampoDescripcion="DESCRIPCION" Proxy="wsControlesContratacion" NumElementos="50"
                                                                    OnClientChange="CambioCPClienteEnvFact">
                                                                </rfn:RFNCodDescripcion>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblCodPostalEnvFact" runat="server" for="cmbCPEnvFact" class="lblEtiquetas">C.P.</label>
                                                                <rfn:RFNDropDownList ID="cmbCPEnvFact" runat="server" Width="100px" PermitirVacio="True"
                                                                    ErrorMessage="Error en Código Postal de la Dirección de envío de facturas" ValidationGroup="vGuardaContrato" Requerido="False"
                                                                    DataTextField="DES_POSTAL" DataValueField="COD_POSTAL" Enabled="true">
                                                                </rfn:RFNDropDownList>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipal">
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblViaEnvFact" runat="server" for="cmbTipoViaEnvFact" class="lblEtiquetas">Tipo de vía</label>
                                                                <rfn:RFNDropDownList ID="cmbTipoViaEnvFact" runat="server" Width="192px" PermitirVacio="True"
                                                                    Requerido="False" ErrorMessage="Error en Tipo de Vía de la Dirección de envío de facturas" ValidationGroup="vGuardaContrato"
                                                                    DataTextField="DES_TIPO_VIA" DataValueField="COD_TIPO_VIA" />
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblCalleEnvFact" runat="server" for="txtCalleEnvFact" class="lblEtiquetas">Calle</label>
                                                                <rfn:RFNTextbox ID="txtCalleEnvFact" Width="331px" runat="server" OnClientChange="validaNumeroCaracteresEnvFact"
                                                                    Requerido="False" MaxLength="49" ErrorMessage="Error en Calle de la Dirección de envío de facturas" ValidationGroup="vGuardaContrato"></rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblNumeroEnvFact" runat="server" for="txtNumEnvFact" class="lblEtiquetas">Número</label>
                                                                <rfn:RFNTextbox ID="txtNumEnvFact" Width="70px" runat="server" OnClientChange="validaNumeroCaracteresEnvFact"
                                                                    Requerido="False" MaxLength="16"></rfn:RFNTextbox>
                                                                <rfn:RFNTextbox ID="txtControlCaracteresConCalleEnvFact" runat="server" Width="0px"
                                                                    Style="text-transform: uppercase" CausesValidation="True" Requerido="false" ErrorMessage="El número de caracteres totales entre los campos: Calle, Número, Portal, Escalera, Piso y Puerta no puede exceder de 50"
                                                                    ValidationGroup="vGuardaContrato" MaxLength="40">
                                                                </rfn:RFNTextbox>
                                                                <rfn:RFNTextbox ID="txtControlCaracteresEnvFact" runat="server" Width="0px" Style="text-transform: uppercase"
                                                                    CausesValidation="True" Requerido="false" ErrorMessage="El número de caracteres totales entre los campos: Número, Portal, Escalera, Piso y Puerta no puede exceder de 16"
                                                                    ValidationGroup="vGuardaContrato" MaxLength="40">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipal">
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblPortalEnvFact" runat="server" for="txtPortalEnvFact" class="lblEtiquetas">Portal</label>
                                                                <rfn:RFNTextbox ID="txtPortalEnvFact" OnClientChange="validaNumeroCaracteresEnvFact"
                                                                    Width="50px" runat="server" Requerido="False" MaxLength="4"></rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblEscaleraEnvFact" runat="server" for="txtEscaleraEnvFact" class="lblEtiquetas">Escalera</label>
                                                                <rfn:RFNTextbox ID="txtEscaleraEnvFact" OnClientChange="validaNumeroCaracteresEnvFact"
                                                                    Width="50px" runat="server" MaxLength="4"></rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblPisoEnvFact" runat="server" for="txtPisoEnvFact" class="lblEtiquetas">Piso</label>
                                                                <rfn:RFNTextbox ID="txtPisoEnvFact" OnClientChange="validaNumeroCaracteresEnvFact"
                                                                    Width="50px" runat="server" MaxLength="2"></rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblPuertaEnvFact" runat="server" for="txtPuertaEnvFact" class="lblEtiquetas">Puerta</label>
                                                                <rfn:RFNTextbox ID="txtPuertaEnvFact" OnClientChange="validaNumeroCaracteresEnvFact"
                                                                    Width="70px" runat="server" MaxLength="2"></rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblNumTelfEnvFact" runat="server" for="txtTelefonoEnvFact" class="lblEtiquetas">Teléfono</label>
                                                                <rfn:RFNTextbox ID="txtTelefonoEnvFact" Width="70px" runat="server" MaxLength="9"
                                                                    TipoDato="Telefono"></rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblNumFaxEnvFact" runat="server" for="txtNumFaxEnvFact" class="lblEtiquetas">Fax</label>
                                                                <rfn:RFNTextbox ID="txtNumFaxEnvFact" Width="70px" runat="server" MaxLength="9" TipoDato="Telefono"></rfn:RFNTextbox>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%--QP-Portugal - QP-Peru--%>
                                                    <div id="dirEnvFactFilial" class=" ocultarControl">
                                                        <div class="subelementosSeccionPrincipal">
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblProvinciaFilial" runat="server" for="txtProvinciaFilial" class="lblEtiquetas"></label>
                                                                <rfn:RFNTextbox ID="txtProvinciaFilial" Width="192px" runat="server" TipoDato="Texto"
                                                                    ErrorMessage="Error en Provincia" ValidationGroup="vGuardaContrato" Requerido="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblPoblacionFilial" runat="server" for="txtPoblacionFilial" class="lblEtiquetas"></label>
                                                                <rfn:RFNTextbox ID="txtPoblacionFilial" Width="300px" runat="server" TipoDato="Texto"
                                                                    ErrorMessage="Error en población" ValidationGroup="vGuardaContrato" Requerido="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                            <div id="cpFilial" class="elementosSeccionPrincipalDS">
                                                                <label id="lblCPFilial" runat="server" for="txtCPFilial" class="lblEtiquetas"></label>
                                                                <rfn:RFNTextbox ID="txtCPFilial" Width="70px" runat="server" TipoDato="Texto"
                                                                    ErrorMessage="Error en Código Postal" ValidationGroup="vGuardaContrato" Requerido="False">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipal">
                                                            <div class="elementosSeccionPrincipalDS">
                                                                <label id="lblDomicilioFacturacionFilial" runat="server" for="txtDomicilioFacturacionFilial" class="lblEtiquetas"></label>
                                                                <rfn:RFNTextbox ID="txtDomicilioFacturacionFilial" Width="700px" runat="server" TipoDato="Texto"
                                                                    ErrorMessage="Error en Domicilio de facturación" ValidationGroup="vGuardaContrato" Requerido="False"
                                                                    MaxLength="100">
                                                                </rfn:RFNTextbox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <%--FIN_QP-Portugal--%>

                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblAtencionEnvFact" runat="server" for="txtAtencionEnvFact" class="lblEtiquetas">A la atención de</label>
                                                            <rfn:RFNTextbox ID="txtAtencionEnvFact" Width="300px" runat="server" CausesValidation="True"
                                                                ValidationGroup="vGuardaContrato" ErrorMessage="Error en 'A la atención de' en la Dirección de envío de facturas"
                                                                MaxLength="70" OnClientChange="CompruebaCaracteres"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblEmailEnvFact" runat="server" for="txtEmailEnvFact" class="lblEtiquetas">Dirección Email</label>
                                                            <rfn:RFNTextbox ID="txtEmailEnvFact" Width="300px" runat="server" TipoDato="Texto"
                                                                CausesValidation="True" ValidationGroup="vGuardaContrato" ErrorMessage="Error en Email de Dirección de envío de facturas"
                                                                MaxLength="255" OnClientChange="compruebaEmail" ToolTip="Si desea introducir varias direcciones de Email, éstas han de separarse con Puntos y coma">
                                                            </rfn:RFNTextbox>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <fieldset id="fsCtDomiBanc" class="seccionesPrincipales3">
                                                    <legend>
                                                        <label id="lblLegendCtrDomiBanc" runat="server">Domiciliación Bancaria</label>
                                                    </legend>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div id="nomColectivo" class="elementosSeccionPrincipal">
                                                            <label id="lblNombreCompleto" runat="server" for="txtNombre" class="lblEtiquetas">Razón Social</label>
                                                            <rfn:RFNTextbox ID="txtNombreCompleto" runat="server" Enabled="False" Width="400px"
                                                                Style="text-transform: uppercase" CausesValidation="True" ErrorMessage="Error en Nombre de Cliente (Domiciliación Bancaria)"
                                                                ValidationGroup="vGuardaContrato" MaxLength="40"></rfn:RFNTextbox>
                                                        </div>
                                                        <div id="nomIndividual" class="elementosSeccionPrincipal" style="display: none">
                                                            <label id="lblNombre" runat="server" for="txtNombre" class="lblEtiquetas">Nombre</label>
                                                            <rfn:RFNTextbox ID="txtNombre" runat="server" Enabled="False" Width="100px" Style="text-transform: uppercase"
                                                                CausesValidation="True" ErrorMessage="Error en Nombre de Cliente (Domiciliación Bancaria)"
                                                                ValidationGroup="vGuardaContrato" MaxLength="15"></rfn:RFNTextbox>
                                                        </div>
                                                        <div id="ape1Individual" class="elementosSeccionPrincipal" style="display: none">
                                                            <label id="lblApellido1" runat="server" for="txtApellido1" class="lblEtiquetas">Primer Apellido</label>
                                                            <rfn:RFNTextbox ID="txtApellido1" runat="server" Enabled="False" Width="100px" Style="text-transform: uppercase"
                                                                CausesValidation="True" ErrorMessage="Error en Apellido 1 del Cliente (Domiciliación Bancaria)"
                                                                ValidationGroup="vGuardaContrato" MaxLength="15"></rfn:RFNTextbox>
                                                        </div>
                                                        <div id="ape2Individual" class="elementosSeccionPrincipal" style="display: none">
                                                            <label id="lblApellido2" runat="server" for="txtApellido2" class="lblEtiquetas">Segundo Apellido</label>
                                                            <rfn:RFNTextbox ID="txtApellido2" runat="server" Enabled="False" Width="100px" Style="text-transform: uppercase"
                                                                CausesValidation="True" ErrorMessage="Error en Apellido 2 del Cliente (Domiciliación Bancaria)"
                                                                ValidationGroup="vGuardaContrato" MaxLength="10"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblTipDocu" runat="server" for="rblColInd" class="lblEtiquetas">Tipo</label>
                                                            <rfn:RFNRadioButtonList ID="rblColInd" runat="server" Enabled="False" CellPadding="0"
                                                                CellSpacing="0" RepeatDirection="Horizontal" Requerido="True" OnClientChange="cambioColInd">
                                                                <asp:ListItem Selected="True" Value="COLECTIVO">Colectivo</asp:ListItem>
                                                                <asp:ListItem Value="INDIVIDUAL">Individual</asp:ListItem>
                                                            </rfn:RFNRadioButtonList>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblNomBanco" runat="server" for="txtNomBanco" class="lblEtiquetas">Banco</label>
                                                            <rfn:RFNTextbox ID="txtNomBanco" runat="server" Enabled="False" Width="350px" Style="text-transform: uppercase"
                                                                CausesValidation="True" ErrorMessage="Error en Nombre de Banco" ValidationGroup="vGuardaContrato"></rfn:RFNTextbox>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblIdentificador" runat="server" for="txtIdentificador" class="lblEtiquetas">CIF</label>
                                                            <rfn:RFNTextIdentificador ID="txtIdentificador" runat="server" Enabled="False" Style="text-transform: uppercase"
                                                                ErrorMessage="Error en CIF" ValidarCIF="True" ValidarNIE="True" ValidarNIF="True"
                                                                ValidationGroup="vGuardaContrato" Requerido="False" MaxLength="10">
                                                            </rfn:RFNTextIdentificador>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                        </div>
                                                    </div>
                                                    <div class="subelementosSeccionPrincipal">
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <div>
                                                                <label id="lblIban" runat="server" for="txtIban" class="lblEtiquetasPadd2">IBAN</label>
                                                                <label id="lblDc" runat="server" for="txtIban" class="lblEtiquetasPadd3">DC</label>
                                                                <label id="lblCCC" runat="server" for="txtIban">CCC</label>
                                                            </div>
                                                            <rfn:RFNIban ID="txtIban" runat="server" ValidationGroup="vGuardaContrato" ErrorMessage="Error en Iban"
                                                                Requerido="False" OnClientChange="cambioIban" />
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS" style="display: none">
                                                            <label id="lblNumCuenta" runat="server" for="txtNumCuenta" class="lblEtiquetas">Cuenta</label>
                                                            <rfn:RFNCuentaBancaria ID="txtNumCuenta" runat="server" Enabled="True" CausesValidation="True"
                                                                ErrorMessage="Error en Cuenta Bancaria" Width="350px" ValidationGroup="vGuardaContrato"
                                                                OnClientChange="cambioCuenta"></rfn:RFNCuentaBancaria>
                                                        </div>
                                                        <div class="elementosSeccionPrincipalDS">
                                                            <label id="lblfact" runat="server" style="color: Red; display: none;">Según los permisos que usted tiene no puede introducir la cuenta bancaria del contrato.</label>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>
                                            <%--                            <asp:UpdatePanel ID="upfacturacion" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
                                <ContentTemplate>--%>
                                            <div class="elementosSeccionPrincipalPadd">
                                                <div class="subelementosSeccionPrincipal">
                                                    <div class="elementosSeccionPrincipal">
                                                        <%-- <rfn:RFNCheckBox ID="chkFactAnal" runat="server" Text="Fact. Analít." BorderStyle="None"
                                                    Checked="True" Enabled="False"></rfn:RFNCheckBox>--%>
                                                    </div>
                                                    <div class="elementosSeccionPrincipal" style="display: none">
                                                        <rfn:RFNCheckBox ID="chkFactVacu" runat="server" Text="Fact. Vacunas." BorderStyle="None"
                                                            Checked="True"></rfn:RFNCheckBox>
                                                    </div>
                                                </div>
                                                <div class="subelementosSeccionPrincipalPadd2" style="display: none">
                                                    <div class="elementosSeccionPrincipalCercano">
                                                        <rfn:RFNCheckBox ID="chkAplicaIPC" runat="server" Text="Aplicar IPC" OnClientClick="chkCambio"></rfn:RFNCheckBox>
                                                    </div>
                                                    <div id="contenedorFecDesdeIPC" runat="server" class="elementosSeccionPrincipal">
                                                        <rfn:RFNCalendar ID="calFecDesdeIPC" runat="server" Enabled="False" Width="75px">
                                                        </rfn:RFNCalendar>
                                                    </div>
                                                </div>
                                                <div class="subelementosSeccionPrincipalPadd2" style="display: none">
                                                    <div class="elementosSeccionPrincipal">
                                                        <div class="subelementosSeccionPrincipal">
                                                            <rfn:RFNCheckBox ID="chkPartVacu" runat="server" Text="Part. Vacunas"></rfn:RFNCheckBox>
                                                        </div>
                                                        <div class="subelementosSeccionPrincipal">
                                                            <rfn:RFNImage ID="imgPartVacu" runat="server" class="lblEtiquetaOculta"></rfn:RFNImage>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="elementosSeccionPrincipalPadd">
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </fieldset>
                                <div id="divOcultargrupoFacturacionPerfiles" runat="server" style="display: none;">
                                    <rfn:RFNPanel ID="grupoFacturacionPerfiles" runat="server" EstiloContenedor="False"
                                        Titulo="Particularización de Perfiles" Visualizacion="Seccion" Collapsable="True"
                                        Collapsed="True" Width="100%" Display="table">
                                        <fieldset id="fsAnalPerfil" class="seccionesPrincipales">
                                            <legend>
                                                <label id="lblFsAnalPerfil" runat="server">Perfiles</label>
                                            </legend>
                                            <div id="mostrarAltaAnaliticaPerfil" class="subelementosSeccionPrincipalPadd2" style="display: block">
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblTipoAnaliticaPerfil" runat="server" for="ccdTipoAnaliticaPerfil" class="lblEtiquetas">Perfil</label>
                                                    <rfn:RFNCodDescripcion ID="ccdTipoAnaliticaPerfil" runat="server" Width="400px" CampoCodigo="A.COD_ANALITICA"
                                                        CampoDescripcion="B.LITERAL" WidthCod="75px" FuenteDatos="SPA.SAnaliticasPerfiles_Read"
                                                        BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Analíticas Perfiles" Proxy="wsControlesContratacion" NumElementos="50"
                                                        Tipo="Procedimiento" />
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <rfn:RFNImage ID="btnInsertaAnaliticaPerfil" runat="server" Visible="True"></rfn:RFNImage>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd2" style="display: block">
                                                <rfn:RFNGridEditable2 ID="gvAnaliticasPerfiles" runat="server" GridLines="Both" CssClass="borde_grid"
                                                    Width="850px" CallBackFunction="manejadorGridAnaliticaPerfil" wsProxy="wsControlesContratacion"
                                                    wsProxyMetodo="AccionesGridAnaliticasPerfilContrato" AutoLoad="False">
                                                    <Configs>
                                                        <rfn:ConfigGE KeyNames="COD_PERFIL, DES_PERFIL, PRECIO" EnableAddRow="False" EnableDeleteRow="True"
                                                            EnableEditRow="True" PosActionButtons="BOTH">
                                                            <Columnas>
                                                                <rfn:RfnTextBoxBound2 HeaderText="Cod. Perfil" DataField="COD_PERFIL" Editable="False" />
                                                                <rfn:RfnTextBoxBound2 HeaderText="Perfil" DataField="DES_PERFIL" Width="550px" Editable="False" />
                                                                <rfn:RfnTextBoxBound2 HeaderText="Precio" DataField="PRECIO" Editable="True" Requerido="True"
                                                                    TipoDato="DecimalPositivo" Width="40px" MinValue="0" />
                                                            </Columnas>
                                                        </rfn:ConfigGE>
                                                    </Configs>
                                                </rfn:RFNGridEditable2>
                                            </div>
                                        </fieldset>
                                    </rfn:RFNPanel>
                                </div>
                                <div id="divOcultargrupoFacturacionCompuestas" runat="server" style="display: none;">
                                    <rfn:RFNPanel ID="grupoFacturacionCompuestas" runat="server" EstiloContenedor="False"
                                        Titulo="Particularización de Analíticas Compuestas" Visualizacion="Seccion" Collapsable="True"
                                        Collapsed="True" Width="100%" Display="table">
                                        <fieldset id="fsAnalCompuesta" class="seccionesPrincipales">
                                            <legend>
                                                <label id="lblFsAnalCompuesta" runat="server">Analíticas Compuestas</label>
                                            </legend>
                                            <div id="mostrarAltaAnaliticaCompuesta" class="subelementosSeccionPrincipalPadd2"
                                                style="display: none">
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblTipoAnaliticaCompuesta" runat="server" for="ccdTipoAnaliticaCompuesta" class="lblEtiquetas">Analitica</label>
                                                    <rfn:RFNCodDescripcion ID="ccdTipoAnaliticaCompuesta" runat="server" Width="400px"
                                                        CampoCodigo="A.COD_ANALITICA" CampoDescripcion="B.LITERAL" WidthCod="75px" FuenteDatos="SPA.SAnaliticasCompuestas_Read"
                                                        BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Analíticas Compuestas" NumElementos="50" Tipo="Procedimiento"
                                                        TipoCodigo="Numerico" Proxy="wsControlesContratacion" />
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <rfn:RFNImage ID="btnInsertaAnaliticaCompuesta" runat="server" Visible="True"></rfn:RFNImage>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <rfn:RFNGridEditable2 ID="gvAnaliticasCompuesta" runat="server" GridLines="Both"
                                                    CssClass="borde_grid" Width="850px" CallBackFunction="manejadorGridAnaliticaCompuesta"
                                                    wsProxy="wsControlesContratacion" wsProxyMetodo="AccionesGridAnaliticasCompuestaContrato" AutoLoad="False">
                                                    <Configs>
                                                        <rfn:ConfigGE KeyNames="COD_ANALITICA, DES_ANALITICA, PRECIO" EnableAddRow="False"
                                                            EnableDeleteRow="True" EnableEditRow="True" PosActionButtons="BOTH">
                                                            <Columnas>
                                                                <rfn:RfnTextBoxBound2 HeaderText="Cod. Analítica" DataField="COD_ANALITICA" Editable="False" />
                                                                <rfn:RfnTextBoxBound2 HeaderText="Analítica" DataField="DES_ANALITICA" Width="550px"
                                                                    Editable="False" />
                                                                <rfn:RfnTextBoxBound2 HeaderText="Precio" DataField="PRECIO" Editable="True" Requerido="True"
                                                                    TipoDato="DecimalPositivo" Width="40px" MinValue="0" />
                                                            </Columnas>
                                                        </rfn:ConfigGE>
                                                    </Configs>
                                                </rfn:RFNGridEditable2>
                                            </div>
                                        </fieldset>
                                    </rfn:RFNPanel>
                                </div>
                                <div id="divOcultargrupoFacturacionSimples" runat="server" style="display: none;">
                                    <rfn:RFNPanel ID="grupoFacturacionSimples" runat="server" EstiloContenedor="False"
                                        Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table"
                                        Titulo="Particularización de Analíticas Simples">
                                        <fieldset id="fsAnalSimple" class="seccionesPrincipales">
                                            <legend>
                                                <label id="lblFsAnalSimple" runat="server">Analíticas Simples</label>
                                            </legend>
                                            <div id="mostrarAltaAnaliticaSimple" class="subelementosSeccionPrincipalPadd2" style="display: none">
                                                <div class="elementosSeccionPrincipalCercano">
                                                    <label id="lblTipoAnaliticaSimple" runat="server" for="ccdTipoAnaliticaSimple" class="lblEtiquetas">Analitica</label>
                                                    <rfn:RFNCodDescripcion ID="ccdTipoAnaliticaSimple" runat="server" Width="400px" CampoCodigo="A.COD_ANALITICA"
                                                        CampoDescripcion="B.LITERAL" WidthCod="75px" FuenteDatos="SPA.SAnaliticasSimples_Read"
                                                        BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5" Titulo="Analíticas Simples" NumElementos="50" Tipo="Procedimiento"
                                                        TipoCodigo="Numerico" Proxy="wsControlesContratacion" />
                                                </div>
                                                <div class="elementosSeccionPrincipal">
                                                    <rfn:RFNImage ID="btnInsertaAnaliticaSimple" runat="server" Visible="True"></rfn:RFNImage>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd2">
                                                <rfn:RFNGridEditable2 ID="gvAnaliticasSimple" runat="server" GridLines="Both" CssClass="borde_grid"
                                                    Width="850px" CallBackFunction="manejadorGridAnaliticaSimple"
                                                    wsProxyMetodo="AccionesGridAnaliticasSimpleContrato" AutoLoad="False">
                                                    <Configs>
                                                        <rfn:ConfigGE KeyNames="COD_ANALITICA, DES_ANALITICA, PRECIO" EnableAddRow="False"
                                                            EnableDeleteRow="True" EnableEditRow="True" PosActionButtons="BOTH">
                                                            <Columnas>
                                                                <rfn:RfnTextBoxBound2 HeaderText="Cod. Analítica" DataField="COD_ANALITICA" Editable="False" />
                                                                <rfn:RfnTextBoxBound2 HeaderText="Analítica" DataField="DES_ANALITICA" Width="550px"
                                                                    Editable="False" />
                                                                <rfn:RfnTextBoxBound2 HeaderText="Precio" DataField="PRECIO" Editable="True" Requerido="True"
                                                                    TipoDato="DecimalPositivo" Width="40px" MinValue="0" />
                                                            </Columnas>
                                                        </rfn:ConfigGE>
                                                    </Configs>
                                                </rfn:RFNGridEditable2>
                                            </div>
                                        </fieldset>
                                    </rfn:RFNPanel>
                                </div>
                            </rfn:RFNPanel>


                            <!--EVOLUTIVO_PRUEBAS_EXTERNAS_VSI-->
                            <div id="muestraGrupoPruebasExternas" class="elementoFila99Por mostrarControl" style="margin: 0px 0px 0px 0px;">
                                <rfn:RFNPanel ID="grupoPruebasExternas" runat="server" EstiloContenedor="False" Titulo="VSI"
                                    Visualizacion="Seccion" Collapsable="True" Collapsed="True" Display="table"
                                    Width="1010px">
                                    <div id="totalPruebas" class="control_derecha" style="margin: 20px 20px 20px 0px; display: none;">
                                        <div class="elementoColumna">
                                            <label id="lblImpPruebasVSI" runat="server" class="lblEtiquetas" style="width: 75px; pointer-events: none; opacity: 0.6; display: none;">IMPORTE TOTAL VSI PREFACTURADA </label>
                                        </div>
                                        <div class="elementoColumna">
                                            <rfn:RFNTextbox ID="txtImpPruebasVSI" runat="server" TipoDato="Moneda" Width="75px" Enabled="False" Text="0"></rfn:RFNTextbox>
                                        </div>
                                    </div>
                                    <div id="mostrarfsRecosVSI" class="subelementosSeccionPrincipal" style="display: none;">
                                        <fieldset id="fsRecosVSI" class="seccionesFieldSetN5">
                                            <legend>
                                                <label id="lblRecosVSI" runat="server">Reconocimientos</label>
                                            </legend>
                                            <!--Rconocimientos-->
                                            <div class="subelementosSeccionPrincipal">
                                                <div class="elementosSeccionPrincipalPadd5">
                                                    <table>
                                                        <tr>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <legend>
                                                                    <label id="lblTramos" runat="server" class="tituloPanelColapsable">Tramos</label>
                                                                </legend>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblTarifa" runat="server" class="lblEtiquetas">Tarifa</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblDesde1" runat="server" class="lblEtiquetas">Desde</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblPrecio1" runat="server" class="lblEtiquetas">Precio</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblDesde2" runat="server" class="lblEtiquetas">Desde</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblPrecio2" runat="server" class="lblEtiquetas">Precio</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblDesde3" runat="server" class="lblEtiquetas">Desde</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblPrecio3" runat="server" class="lblEtiquetas">Precio</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblDesde4" runat="server" class="lblEtiquetas">Desde</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblPrecio4" runat="server" class="lblEtiquetas">Precio</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <label id="lblNIncluidos" runat="server" for="txtNIncluidos" class="lblEtiquetas">Nº Incluidos</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblImpUndIncl" runat="server" for="txtImpUndIncl" class="lblEtiquetas">€/Und Incl.</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblImpRPF" runat="server" for="txtImpRPF" class="lblEtiquetas">IMP. Reco.P.F</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblImporteBRTarifa" runat="server" class="control_txt" style="width: 70px; pointer-events: none; opacity: 0.6">Bajo Riesgo:</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtTarifaBR" Width="50px" runat="server" TipoDato="Moneda"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeBR1" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioBR1" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeBR2" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioBR2" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeBR3" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioBR3" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeBR4" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioBR4" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <rfn:RFNTextbox runat="server" ID="txtNIncluidos" MaxLength="6" Enabled="False" TipoDato="EnteroPositivo" CssClass="control_txt" Width="50px"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox runat="server" ID="txtImpUndIncl" Enabled="False" CssClass="control_txt" TipoDato="Moneda" Width="70px">
                                                                </rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox runat="server" ID="txtImpRPF" Enabled="False" CssClass="control_txt" Width="70px" TipoDato="Moneda">
                                                                </rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td></td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <label id="lblImporteARTarifa" runat="server" style="width: 70px">Alto Riesgo:</label>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtTarifaAR" Width="50px" runat="server" TipoDato="Moneda"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeAR1" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioAR1" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeAR2" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioAR2" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeAR3" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioAR3" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtDesdeAR4" Width="50px" runat="server" TipoDato="EnteroPositivo"
                                                                    Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                            <td>
                                                                <rfn:RFNTextbox ID="txtPrecioAR4" Width="50px" runat="server" TipoDato="Moneda"
                                                                    MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                            </td>
                                                            <td>&nbsp
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>





                                    <fieldset id="fsPruebasExternas" class="seccionesFieldSetN5">
                                        <legend>
                                            <label id="lblOtrasPruebasExternas" runat="server">Resto de pruebas VSI</label>
                                        </legend>



                                        <div id="chksFiltroPruebas" class="elementoColumna mostrarControl">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <fieldset id="fsVSITotal" class="seccionesPrincipales">
                                                            <legend>
                                                                <label id="RFNLabel5" runat="server">Número total de Pruebas VSI en el contrato</label>
                                                            </legend>
                                                            <div class="elementosSeccionPrincipal">
                                                                <rfn:RFNTextbox ID="txtvsitotal" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                    MaxLength="6" Enabled="False" ToolTip="VSI"></rfn:RFNTextbox>

                                                                <div style="display: none">
                                                                    <label id="btnrecargar" runat="server" class="lblEtiquetaBoton" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; font-weight: bold; width: 80px; display: none; margin: 0px 0px 0px 30px;">Filtrar lista</label>
                                                                </div>
                                                            </div>

                                                        </fieldset>

                                                    </td>
                                                </tr>


                                                <tr>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkPerfAnal" runat="server" OnClientClick="cambiarchkPerfAnal"
                                                            Text="Perfiles Analíticas" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                    <td>&nbsp
                                                    </td>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkAnalSimples" runat="server" OnClientClick="cambiarchkAnalSimples"
                                                            Text="Analíticas Simples" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                    <td>&nbsp
                                                    </td>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkAnalCompuestas" runat="server" OnClientClick="cambiarchkAnalCompuestas"
                                                            Text="Analíticas Compuestas" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                    <td>&nbsp
                                                    </td>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkAbsent" runat="server" OnClientClick="cambiarchkAbsent"
                                                            Text="Absentismo" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkPrubComplInt" runat="server" OnClientClick="cambiarchkPrubComplInt"
                                                            Text="Pruebas Complementarias internas" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                    <td>&nbsp
                                                    </td>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkPrubComplExt" runat="server" OnClientClick="cambiarchkPrubComplExt"
                                                            Text="Pruebas Complementarias externas" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                    <td>&nbsp
                                                    </td>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkVacuna" runat="server" OnClientClick="cambiarchkVacuna"
                                                            Text="Vacunas" Font-Bold="True" AutoPostBack="False" Checked="true" />
                                                    </td>
                                                    <td>&nbsp
                                                    </td>
                                                    <td>
                                                        <rfn:RFNCheckBox ID="chkReco" runat="server" OnClientClick="cambiarchkReco"
                                                            Text="Reconocimientos" Font-Bold="True" AutoPostBack="False" Checked="false" Visible="false" />
                                                    </td>
                                                </tr>


                                            </table>
                                        </div>



                                        <!--Combo_Elegir_Pruebas-->
                                        <div id="divCcdPruebasExternas" class="elementoColumna" style="display: none">
                                            <label id="lblccdPruebasExternas" runat="server" for="ccdPruebasExternas" class="lblEtiquetas">Prueba</label>
                                            <rfn:RFNCodDescripcion ID="ccdPruebasExternas" runat="server" Width="450px" CampoCodigo="PRUEBA"
                                                CampoDescripcion="DES_PRUEBA" FuenteDatos="SPA.SPruebasVSI_Read" BusquedaAutomatica="True" MinCaracteresBusquedaAutomatica="5"
                                                Titulo="Pruebas VSI" WidthCod="75px" Tipo="Procedimiento" NumElementos="50"
                                                TipoCodigo="Alfanumerico" ErrorMessage="Error en Pruebas VSI (Seleccione Prueba)"
                                                Requerido="False" Enabled="false"
                                                ValidationGroup="" Proxy="wsControlesContratacion"
                                                OnClientChange="cambioccdBusqPruebaExterna">
                                            </rfn:RFNCodDescripcion>
                                        </div>
                                        <%--<div id="divBtnInsertarPrueba" class="elementoColumna ocultarControl">
                                    <label id="btninsertarPrueba" runat="server" class="lblEtiquetaBoton" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; font-weight: bold; width: 110px; margin: 15px 0px 0px 30px;">Añadir Prueba</label>
                                </div>--%>
                                        <!--Combo_Elegir_Pruebas-->

                                        <%--tabla de checks--%>



                                        <!--Grid_Pruebas_VSI-->
                                        <div id="gridgvPruebasExternasContrato" runat="server" class="productosGridConScrollHoriz">
                                            <rfn:RFNGridEditable2 ID="gvPruebasExternasContrato" runat="server" GridLines="Both" CallBackFunction="manejadorGridPruebasVSIContrato"
                                                wsProxyMetodo="AccionesGridContratoPruebasExternas" AutoLoad="True" Font-Size="XX-Small">
                                                <Configs>

                                                    <%--PRUEBAS_VSI--%>
                                                    <rfn:ConfigGE KeyNames="COD_PRUEBA"
                                                        EnableAddRow="False" EnableDeleteRow="false" EnableEditRow="false" PosActionButtons="BOTH">
                                                        <Columnas>
                                                            <rfn:RFNLabelBound2 DataField="COD_PRUEBA" HeaderText="Cód. Prueba" Width="10%" />
                                                            <rfn:RFNLabelBound2 DataField="COD_PRUEBA_TABMT" HeaderText="Cód. Prueba" Width="10%" Visible="false" />
                                                            <rfn:RFNLabelBound2 DataField="DES_PRUEBA" HeaderText="Descripción Prueba" Width="35%" />
                                                            <rfn:RfnTextBoxBound2 DataField="NUM_INCLUIDAS" HeaderText="Nº Unid. Incluidas" Width="75" Editable="True" TipoDato="EnteroPositivo" Requerido="true" ErrorMessage="Ha de introducir la cantidad." />
                                                            <rfn:RfnTextBoxBound2 DataField="IMP_UNI_INC" HeaderText="€ Unidad Incluida" Width="100" Editable="True" TipoDato="Moneda" Requerido="true" ErrorMessage="Ha de introducir el importe." />
                                                            <rfn:RfnTextBoxBound2 DataField="IMP_UNI_EXC" HeaderText="€ Unidad Excluida" Width="100" Editable="True" TipoDato="Moneda" Requerido="true" ErrorMessage="Ha de introducir el importe." />
                                                            <rfn:RfnCheckBoxBound2 DataField="IND_TRAMOS" HeaderText="Tramos" Width="75" Editable="false" LabelChecked="S" LabelNotChecked="N" />
                                                            <rfn:RFNLabelBound2 DataField="IMP_PRUEBA" HeaderText="€ Tarifa" Width="100" />

                                                            <rfn:RfnTextBoxBound2 DataField="CANT_TRAMO_1" HeaderText="Nº Desde" Width="75" Editable="True" TipoDato="EnteroPositivo" Requerido="false" ErrorMessage="Ha de introducir la cantidad." />
                                                            <rfn:RfnTextBoxBound2 DataField="IMP_TRAMO_1" HeaderText="€ Unid. Excluida" Width="100" Editable="True" TipoDato="Moneda" Requerido="false" ErrorMessage="Ha de introducir el importe." />
                                                            <rfn:RfnTextBoxBound2 DataField="CANT_TRAMO_2" HeaderText="Nº Desde" Width="75" Editable="True" TipoDato="EnteroPositivo" Requerido="false" ErrorMessage="Ha de introducir la cantidad." />
                                                            <rfn:RfnTextBoxBound2 DataField="IMP_TRAMO_2" HeaderText="€ Unid. Excluida" Width="100" Editable="True" TipoDato="Moneda" Requerido="false" ErrorMessage="Ha de introducir el importe." />
                                                            <rfn:RfnTextBoxBound2 DataField="CANT_TRAMO_3" HeaderText="Nº Desde" Width="75" Editable="True" TipoDato="EnteroPositivo" Requerido="false" ErrorMessage="Ha de introducir la cantidad." />
                                                            <rfn:RfnTextBoxBound2 DataField="IMP_TRAMO_3" HeaderText="€ Unid. Excluida" Width="100" Editable="True" TipoDato="Moneda" Requerido="false" ErrorMessage="Ha de introducir el importe." />
                                                            <rfn:RfnTextBoxBound2 DataField="CANT_TRAMO_4" HeaderText="Nº Desde" Width="75" Editable="True" TipoDato="EnteroPositivo" Requerido="false" ErrorMessage="Ha de introducir la cantidad." />
                                                            <rfn:RfnTextBoxBound2 DataField="IMP_TRAMO_4" HeaderText="€ Unid. Excluida" Width="100" Editable="True" TipoDato="Moneda" Requerido="false" ErrorMessage="Ha de introducir el importe." />
                                                            <rfn:RfnTextBoxBound2 DataField="DES_OBSERVACIONES" HeaderText="Observaciones" Width="100" Editable="True" TipoDato="Texto" Requerido="false" MaxLength="300" />
                                                        </Columnas>
                                                    </rfn:ConfigGE>

                                                    <%--TRAMOS--%>
                                                    <%--<rfn:ConfigGE KeyNames="ID_PRESUPUESTO"
                                                EnableAddRow="False" EnableDeleteRow="True" EnableEditRow="True" PosActionButtons="BOTH" DataFieldEnableAddChildRows="IND_ANIDABLE">
                                                <Columnas>
                                                    <rfn:RFNLabelBound2 DataField="ID_REG" HeaderText="ID_REG" Width="75" Visible="true"/>
                                                    <rfn:RFNLabelBound2 DataField="ID_PRESUPUESTO" HeaderText="ID_PRESUPUESTO" Width="75" Visible="true"/>
                                                    <rfn:RFNLabelBound2 DataField="FEC_EFECTO" HeaderText="FEC_EFECTO" Width="75" Visible="true"/>
                                                    <rfn:RFNLabelBound2 DataField="COD_PRUEBAVSI" HeaderText="Cód. Prueba" Width="75"/>
                                                    <rfn:RFNLabelBound2 DataField="NUM_TRAMO" HeaderText="NUM_TRAMO_b" Width="10%" visible="false"/>
                                                    <rfn:RfnTextBoxBound2 DataField="NUM_DESDE" HeaderText="Desde" Width="50" Editable="True" TipoDato="EnteroPositivo" Requerido="true" ErrorMessage="Ha de introducir la cantidad."/>
                                                    <rfn:RfnTextBoxBound2 DataField="NUM_HASTA" HeaderText="Hasta" Width="50" Editable="True" TipoDato="EnteroPositivo" Requerido="true" ErrorMessage="Ha de introducir la cantidad."/>
                                                    <rfn:RfnTextBoxBound2 DataField="IMP_UNI_EXC" HeaderText="€ Unidad Excluida" Width="100" Editable="True"  TipoDato="Moneda" Requerido="true" ErrorMessage="Ha de introducir el importe."/>
                                                </Columnas>
                                            </rfn:ConfigGE>--%>
                                                </Configs>
                                            </rfn:RFNGridEditable2>
                                        </div>


                                        <%--MOSTRAR COSTE TOTAL PRUEBAS VSI--%>
                                        <div id="mostrarImporteTotalPruebasVSI" class="elementoFila99Por mostrarControl">
                                            <div class="elementoFila99Por">
                                                <br />
                                            </div>
                                            <div class="elementoFila99Por">
                                                <div class="elementoColumna">
                                                    <label id="lbCosteTotalPruebasVSI" runat="server" style="font-weight: bold">Coste Total Pruebas VSI incluidas:</label>
                                                </div>
                                                <div class="elementoColumna">
                                                    <rfn:RFNTextbox ID="txtCosteTotalPruebasVSI" runat="server" TipoDato="Moneda"
                                                        Width="75px" Enabled="False" Font-Bold="True" Text="0" />
                                                </div>
                                            </div>
                                            <div class="elementoFila99Por">
                                                <br />
                                            </div>
                                        </div>

                                    </fieldset>

                                </rfn:RFNPanel>
                            </div>
                            <!--EVOLUTIVO_PRUEBAS_EXTERNAS_VSI-->


                            <rfn:RFNPanel ID="grupoAnexo" runat="server" EstiloContenedor="False" Titulo="Anexos"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <div id="crearAnexo" runat="server" class="subelementosSeccionPrincipalAnexo" clientidmode="Inherit">
                                    <label id="lblCrearAnexo" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 100px">Nuevo Anexo</label>
                                </div>

                                <div id="crearAnexoAAEE" style="display: none" runat="server" class="subelementosSeccionPrincipalAnexo" clientidmode="Inherit">
                                    <label id="lblCrearAnexoAAEE" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 100px">Nuevo Anexo AAEE</label>
                                </div>


                                <%--anexos analiticas  y anexos contra bayes--%>
                                <div class="subelementosSeccionPrincipalAnexo">

                                    <div id="crearAnexoAnaliticas" runat="server" class="elementosSeccionPrincipal" clientidmode="Inherit" style="display: none">
                                        <label id="lblCrearAnexoAnalitica" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 100px">Nuevo Anexo Analiticas</label>
                                    </div>

                                    <div id="crearAnexoRenovacion" runat="server" class="elementosSeccionPrincipal" clientidmode="Inherit" style="display: none">
                                        <label id="lblCrearAnexoRenovacion" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 100px">Nuevo Anexo Renovacion</label>
                                    </div>

                                    <div class="elementosSeccionPrincipal">
                                        <div id="PanelPopAnexoRenovacion" class="popupControlAnexoRenovacion" style="display: none; width: 650px; top: 500px;">
                                            <div class="control_derecha">
                                                <rfn:RFNImage ID="imgGuardarpopUpAnexoRenovacion" runat="server" />
                                                <rfn:RFNImage ID="imgCierrepopUpAnexoRenovacion" runat="server" />
                                            </div>
                                            <div class="elementoFila99Por">
                                                <fieldset id="fsDatosAnexoRenovacion" class="elementoFila99Por" style="margin: 0px 20px 20px 10px; width: 96%;">
                                                    <legend>
                                                        <label id="lblLegendHistDocumento" runat="server">Anexo Renovación</label>
                                                    </legend>
                                                    <div class="elementoColumna">
                                                        <fieldset id="fsDatosContrato" class="seccionesPrincipales_prueba" style="width: 94%;">
                                                            <legend>
                                                                <label id="RFNLabel2" runat="server">Datos Contrato</label>
                                                            </legend>
                                                            <div class="subelementosSeccionPrincipal">
                                                                <div class="elementosSeccionPrincipalCercano">
                                                                    <label id="lblCodContrato" runat="server" for="txtCodContrato" class="lblEtiquetas">Cod. Contrato</label>
                                                                    <rfn:RFNTextbox runat="server" ID="txtCodContrato" CausesValidation="False" Style="text-align: right"
                                                                        Requerido="True" Enabled="False" CssClass="control_txt" Width="75px">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="elementosSeccionPrincipalCercano">
                                                                    <label id="lblCtrtSAP" runat="server" for="txtCtrtSAP" class="lblEtiquetas">Contrato SAP</label>
                                                                    <rfn:RFNTextbox runat="server" ID="txtCtrtSAP" CausesValidation="False" Style="text-align: right"
                                                                        Requerido="True" Enabled="False" CssClass="control_txt" Width="95px">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="elementosSeccionPrincipalCercano">
                                                                    <label id="lblCodAnexo" runat="server" for="txtCodAnexo" class="lblEtiquetas">Anexo</label>
                                                                    <rfn:RFNTextbox runat="server" ID="txtCodAnexo" CausesValidation="False" Style="text-align: right"
                                                                        Requerido="True" Enabled="False" CssClass="control_txt" Width="95px">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                                <div class="elementosSeccionPrincipalCercano">
                                                                    <label id="lblFecAnexoRenovacion" runat="server" class="lblEtiquetas">Fecha anexo</label>
                                                                    <rfn:RFNCalendar ID="calFechaAnexoRenovacion" runat="server" Enabled="False"
                                                                        Requerido="True" Width="75px"></rfn:RFNCalendar>
                                                                </div>
                                                                <div class="elementosSeccionPrincipalCercano">
                                                                    <label id="lblRazonSocialAnexoRenovacion" runat="server" for="txtCodRazonSocialAnexoRenovacion" class="lblEtiquetas">Razón Social</label>
                                                                    <rfn:RFNTextbox runat="server" ID="txtCodRazonSocialAnexoRenovacion" Requerido="true" Enabled="false" Style="text-align: left" CssClass="control_txt" Width="75px"> 
                                                                    </rfn:RFNTextbox>
                                                                    <rfn:RFNTextbox runat="server" ID="txtDesRazonSocialAnexoRenovacion" Requerido="true" Enabled="false" Style="text-align: left" CssClass="control_txt" Width="325px">
                                                                    </rfn:RFNTextbox>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                        <fieldset id="fsModalidadesContrato" class="seccionesPrincipales_prueba" style="width: 94%;">
                                                            <legend>
                                                                <label id="lblImpContrato" runat="server" class="lblEtiquetasPadd" style="pointer-events: none; opacity: 0.6; border-collapse: collapse">Modalidades contrato</label>
                                                            </legend>
                                                            <table style="border-collapse: collapse;">
                                                                <tr style="border-collapse: collapse;">
                                                                    <%--Cheks--%>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNCheckBox ID="chkModSTCtrt" runat="server" Text="ST" Enabled="False"></rfn:RFNCheckBox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNCheckBox ID="chkModHICtrt" runat="server" Text="HI" Enabled="False"></rfn:RFNCheckBox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNCheckBox ID="chkModEPCtrt" runat="server" Text="EP" Enabled="False"></rfn:RFNCheckBox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModSheCtrt" runat="server" for="txtModSheCtrt" class="lblEtiquetasPadd">SHE</label>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNCheckBox ID="chkModMTCtrt" runat="server" Text="MT" Enabled="False"></rfn:RFNCheckBox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModTotCtrt" runat="server" for="txtModTotCtrt" class="lblEtiquetasPadd">Total</label>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr style="border-collapse: collapse">
                                                                    <%--Cajas de texto--%>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtModSTCtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtModHICtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtModEPCtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtModSheCtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtModMTCtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtModTotCtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <table>
                                                                <tr>
                                                                    &nbsp;
                                                                </tr>
                                                                <tr>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblHDCtrt" runat="server" class="seccionesPrincipales_prueba" style="width: 70px; pointer-events: none; opacity: 0.6; width: 92%;">Importe Hospital Digital</label>

                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtHDCtrt" Width="70px" runat="server" TipoDato="Moneda" Enabled="False" Text="0,00"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%--RECOS--%>
                                                            <fieldset id="fsReconocimientosContrato" class="seccionesPrincipales_prueba" style="width: 92%;">
                                                                <legend>
                                                                    <label id="lblRPFCtrato" runat="server">Reconocimientos</label>
                                                                </legend>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblRBPCtrt" runat="server" for="txtRBPCtrt" class="lblEtiquetas">Bajo Riesgo</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtRBPCtrt" Width="100px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblRAPCtrt" runat="server" for="txtRAPCtrt" class="lblEtiquetas">Alto Riesgo</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtRAPCtrt" Width="100px" runat="server" TipoDato="Moneda"
                                                                                Enabled="False"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblRPFIncluidosCtrt" runat="server" for="txtRPFIncluidosCtrt" class="lblEtiquetas">Incluye</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtRPFIncluidosCtrt" Width="40px" runat="server" TipoDato="EnteroPositivo"
                                                                                MaxLength="6" Enabled="False"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblModRPFCtrt" runat="server" for="txtModRPFCtrt" class="lblEtiquetas">Importe RPF</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtModRPFCtrt" Width="80px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </fieldset>
                                                        </fieldset>
                                                        <fieldset id="fsModalidadesAnexo" class="seccionesPrincipales_prueba" style="width: 94%;">
                                                            <legend>
                                                                <label id="lblImpAnexo" runat="server" class="lblEtiquetasPadd" style="border-collapse: collapse">Modalidades antes de Bayes</label>
                                                            </legend>
                                                            <table style="border-collapse: collapse;">
                                                                <tr style="border-collapse: collapse;">
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModSTAnx" runat="server" for="txtModSTAnx" class="lblEtiquetasPadd">ST</label>
                                                                        <rfn:RFNTextbox ID="txtModSTAnx" Width="70px" runat="server" TipoDato="Moneda" OnClientChange="cambioModSTAnexo" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModHIAnx" runat="server" for="txtModHIAnx" class="lblEtiquetasPadd">HI</label>
                                                                        <rfn:RFNTextbox ID="txtModHIAnx" Width="70px" runat="server" TipoDato="Moneda" OnClientChange="cambioModHIAnexo" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModEPAnx" runat="server" for="txtModEPAnx" class="lblEtiquetasPadd">EP</label>
                                                                        <rfn:RFNTextbox ID="txtModEPAnx" Width="70px" runat="server" TipoDato="Moneda" OnClientChange="cambioModEPAnexo" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModSheAnx" runat="server" for="txtModSheAnx" class="lblEtiquetasPadd">SHE</label>
                                                                        <rfn:RFNTextbox ID="txtModSheAnx" Width="70px" runat="server" TipoDato="Moneda" OnClientChange="cambioModSHEAnexo"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModMTAnx" runat="server" for="txtModMTAnx" class="lblEtiquetasPadd">MT</label>
                                                                        <rfn:RFNTextbox ID="txtModMTAnx" Width="70px" runat="server" TipoDato="Moneda" OnClientChange="cambioModMTAnexo"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblModTOTALAnx" runat="server" for="txtModTotAnx" class="lblEtiquetasPadd">TOTAL</label>
                                                                        <rfn:RFNTextbox ID="txtModTotAnx" Width="70px" runat="server" TipoDato="Moneda" Enabled="False"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <table>
                                                                <tr>
                                                                    &nbsp;
                                                                </tr>
                                                                <tr>
                                                                    <td style="border-collapse: collapse">
                                                                        <label id="lblHDAnx" runat="server" class="seccionesPrincipales_prueba" style="width: 70px; pointer-events: none; opacity: 0.6; width: 92%;">Importe Hospital Digital</label>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNCheckBox ID="chkIPCAnaliticas" runat="server" Text="IPC Analíticas"></rfn:RFNCheckBox>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="border-collapse: collapse">
                                                                        <rfn:RFNTextbox ID="txtHDAnx" Width="70px" runat="server" TipoDato="Moneda" Enabled="False" Text="0,00" OnClientChange="cambioHDAnexo"></rfn:RFNTextbox>
                                                                    </td>
                                                                    <td>&nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%--RECOS ANEXO RENOVACION--%>
                                                            <fieldset id="fsReconocimientosAnexo" class="seccionesPrincipales_prueba" style="width: 92%;">
                                                                <legend>
                                                                    <label id="lblRPFAnexo" runat="server">Reconocimientos</label>
                                                                </legend>
                                                                <div class="subelementosSeccionPrincipal">
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblRBPAnexo" runat="server" for="txtRBPAnexo" class="lblEtiquetas">Bajo Riesgo</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtRBPAnexo" Width="100px" runat="server" TipoDato="Moneda"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblRAPAnexo" runat="server" for="txtRAPAnexo" class="lblEtiquetas">Alto Riesgo</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtRAPAnexo" Width="100px" runat="server" TipoDato="Moneda"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblRPFIncluidosAnexo" runat="server" for="txtRPFIncluidosAnexo" class="lblEtiquetas">Incluye</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtRPFIncluidosAnexo" Width="40px" runat="server" TipoDato="EnteroPositivo" MaxLength="6"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                        </div>
                                                                    </div>
                                                                    <div class="elementosSeccionPrincipalCercano" id="RPFAnexoRenovacion">
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <label id="lblModRPFAnexo" runat="server" for="txtModRPFAnexo" class="lblEtiquetas">Importe RPF</label>
                                                                        </div>
                                                                        <div class="subelementosSeccionPrincipal">
                                                                            <rfn:RFNTextbox ID="txtModRPFAnexo" Width="80px" runat="server" TipoDato="Moneda" OnClientChange="cambioModRPFAnexo"></rfn:RFNTextbox>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </fieldset>
                                                        </fieldset>
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <fieldset id="fsAnexo" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendAnexo" runat="server">Anexos</label>
                                    </legend>
                                    <div class="productosGridConScrollHoriz">
                                        <rfn:RFNGridEditable2 ID="gvAnexos" runat="server" GridLines="Both" CssClass="borde_grid"
                                            Width="850px" CallBackFunction="manejadorGridAnexos" wsProxyMetodo="AccionesGridAnexos"
                                            AutoLoad="False">
                                            <Configs>
                                                <rfn:ConfigGE KeyNames="ID_CONTRATO, ID_ANEXO, COD_ANEXO" EnableAddRow="False" EnableDeleteRow="False"
                                                    EnableEditRow="False" PosActionButtons="BOTH">
                                                    <Columnas>
                                                        <rfn:RFNImageBound2 HeaderText="" Src="propio/detalle_grid.png" Width="30px" Name="Detalle" />
                                                        <rfn:RFNLabelBound2 HeaderText="Contrato" DataField="ID_CONTRATO" Width="30px" Visible="False" />
                                                        <rfn:RFNLabelBound2 HeaderText="Anexo" DataField="ID_ANEXO" Width="30px" Visible="False" />
                                                        <rfn:RFNLabelBound2 HeaderText="Nº" DataField="COD_ANEXO" Width="30px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Estado" DataField="DES_ESTADO" Width="75px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Precio" DataField="IMP_ANUAL" Width="60px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Domicilio" DataField="IND_DOMICILIO" Width="30px"
                                                            Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Fir. Empre" DataField="IND_FIRM_EMP" Width="30px"
                                                            Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Modalidad" DataField="IND_MODALIDAD" Width="30px"
                                                            Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Nuevo Cent" DataField="IND_CENT" Width="30px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Cambio Cent" DataField="IND_CAM_CENT" Width="30px"
                                                            Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Fir. FM" DataField="IND_FIRM_FM" Width="30px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Fecha Firma" DataField="FEC_FIRMA" Width="50px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Cambio Servicio" DataField="IND_CAM_SERV" Width="30px"
                                                            Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="C. Específicas" DataField="IND_CAM_ESP" Width="30px"
                                                            Visible="False" />
                                                        <rfn:RFNLabelBound2 HeaderText="Ind.Estado" DataField="IND_ESTADO_ANEXO" Width="30px"
                                                            Visible="False" />
                                                        <rfn:RFNLabelBound2 HeaderText="Anexo Regularizado" DataField="IND_ANEXO_REGUL" Width="20px"
                                                            Visible="true" />
                                                        <rfn:RFNLabelBound2 HeaderText="Motivo Anexo" DataField="DES_MOTANEXO" Width="20px"
                                                            Visible="true" />
                                                        <rfn:RFNLabelBound2 HeaderText="Precio Contrato" DataField="IMP_CONTRATO" Width="60px" Visible="True" />
                                                        <rfn:RFNLabelBound2 HeaderText="Usuario" DataField="NOM_LOGIN" Width="20px"
                                                            Visible="true" />
                                                        <rfn:RFNLabelBound2 HeaderText="Fecha Alta" DataField="FEC_ALTA" Width="50px" Visible="True" />
                                                        <rfn:RFNImageBound2 HeaderText="" Src="propio/ok-button.png" Width="30px" Name="Regularizar"
                                                            VisibleEnEdicion="false" />

                                                    </Columnas>
                                                </rfn:ConfigGE>
                                            </Configs>
                                        </rfn:RFNGridEditable2>
                                    </div>
                                </fieldset>
                            </rfn:RFNPanel>

                            <%--dvv observaciones y actividaeds--%>
                            <div id="panelobser" runat="server" style="display: block">
                                <rfn:RFNPanel ID="rfnObservaciones" runat="server" EstiloContenedor="False" Titulo="Consulta de Observaciones/Actividades (Contratos Migrados)"
                                    Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Style="display: none" Display="table">
                                    <%----%>


                                    <fieldset id="fsobservacioens" class="seccionesPrincipales">
                                        <legend>
                                            <label id="lblbobser" runat="server">Búsqueda</label>
                                        </legend>
                                        <rfn:RFNDropDownList runat="server" ID="ddlobser" CausesValidation="True"
                                            Width="450px"
                                            PermitirVacio="True" Requerido="False" CssClass="control_ddl" Enabled="True" OnClientChange="VerObservaciones"
                                            TextoItemVacio="-- Observaciones --">
                                        </rfn:RFNDropDownList>
                                        <rfn:RFNButton ID="Cambiobserv" runat="server" Style="display: none" ScriptEnabled="true" />
                                        <div class="subelementosSeccionPrincipalPadd">
                                            <label id="lblbobser2" runat="server" for="txtCtrObserv" class="lblEtiquetas">Observaciones del contrato</label>
                                            <rfn:RFNTextbox runat="server" ID="txtCtrObserv" CausesValidation="False" Requerido="False"
                                                Enabled="true" CssClass="control_txt" TextMode="MultiLine" TipoDato="Texto" ReadOnly="true"
                                                Width="100%" Height="200px">
                                            </rfn:RFNTextbox>
                                        </div>
                                    </fieldset>
                                </rfn:RFNPanel>
                            </div>

                            <%--panel de actividades--%>
                            <%-- <rfn:RFNPanel ID="rfnActividades" runat="server" EstiloContenedor="False" Titulo="Actividades del Contrato"
                        Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table" style="display: none" >
                         </rfn:RFNPanel>
                            --%>

                            <%-- OTRAS ACTIVIDADES INCLUIDAS --%>

                            <rfn:RFNPanel ID="grupoOtrasActividades" runat="server" EstiloContenedor="False" Titulo="Otras Actividades Incluidas"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <fieldset id="fsGrupoOtrasActividades" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendGrupoOtrasActividades" runat="server">Actividades de formación</label>
                                    </legend>
                                    <div class="subelementosSeccionPrincipalPadd2">
                                        <div class="subelementosSeccionPrincipalPadd">
                                            <%-- TABLA CURSOS --%>
                                            <%-- OBTENER PRODUCTOS CURSOS --%>
                                            <div id="contenedorGrupoOtrasActividadesCursos_1" runat="server" class="elementosSeccionPrincipal">

                                                <rfn:RFNPanel ID="pnlCursosFormacion" runat="server" Display="table" Width="100%">
                                                    <rfn:RFNGridEditable2 ID="gvCursosFormacion" runat="server" WebServiceScript="Contratacion.Contrato.Web.ContratosWebServiceAjax.CursosFormacion"
                                                        CallBackFunction="manejadorGridCursosFormacion" GridLines="Both" CssClass="borde_grid"
                                                        Width="895px">
                                                        <Configs>
                                                            <rfn:ConfigGE KeyNames="IDCONTFH" EnableAddRow="True" EnableDeleteRow="True" EnableEditRow="False">
                                                                <Columnas>
                                                                    <rfn:RFNLabelBound2 Visible="False" DataField="IDCONTFH" HeaderText="IDCONTFH" Width="150px" />
                                                                    <rfn:RfnCodDescripcionBound2 Editable="false" DataField="CODCURSO" DataValueField="DESCURSO" CampoCodigo="CODCURSO"
                                                                        CampoDescripcion="DESCURSO" FuenteDatos="Contratacion.Contrato.Web.ContratosWebServiceAjax.Cursos" Width="595px"
                                                                        Titulo="Cursos" Tipo="WebService" WidthCod="75px" TipoCodigo="Numerico" MaxLengthCodigo="10" MostrarCodigo="True" MostrarCodigoEnDatos="True" HeaderText="CURSOS" BusquedaAutomatica="False" EventoCambio="true" />

                                                                    <rfn:RfnTextBoxBound2 DataField="DESOBSERVACIONES" HeaderText="Nº Acc. Formativas" Width="150px" TipoDato="EnteroPositivo" Requerido="true" ErrorMessage="Debe introducir el número de acciones formativas." />
                                                                    <rfn:RFNLabelBound2 HeaderText="USUARIO ALTA" DataField="NOMPERSONA" Width="150px" Visible="True" />
                                                                </Columnas>
                                                            </rfn:ConfigGE>
                                                        </Configs>
                                                    </rfn:RFNGridEditable2>
                                                </rfn:RFNPanel>
                                                <br />

                                            </div>
                                        </div>
                                    </div>
                                </fieldset>
                            </rfn:RFNPanel>

                            <%-- FIN OTRAS ACTIVIDADES INCLUIDAS --%>



                            <rfn:RFNPanel ID="grupoCtrBaja" runat="server" EstiloContenedor="False" Titulo="Baja del Contrato"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <fieldset id="fsCtrBaja" class="seccionesPrincipales">
                                    <legend>
                                        <label id="lblLegendCtrBaja" runat="server">Baja del Contrato</label>
                                    </legend>
                                    <div class="subelementosSeccionPrincipalPadd2">
                                        <div class="subelementosSeccionPrincipalPadd">
                                            <div id="contenedorCtrFecBaja" runat="server" class="elementosSeccionPrincipal">
                                                <label id="lblCtrFecBaja" runat="server" class="lblEtiquetas" style="width: 75px; pointer-events: none; opacity: 0.6: True">Fecha de Baja</label>
                                                <rfn:RFNCalendar ID="calCtrFecBaja" runat="server" ErrorMessage="Fecha de Baja Obligatoria"
                                                    ValidationGroup="vGuardaContrato" Enabled="True" OnClientChange="cambioCtrcalFecBaja"
                                                    Width="75px">
                                                </rfn:RFNCalendar>
                                            </div>
                                            <div class="elementosSeccionPrincipal">
                                                <rfn:RFNCheckBox ID="chkCtrBajaFutura" runat="server" Text="Baja Futura" OnClientClick="bajaCtrFutura"></rfn:RFNCheckBox>
                                            </div>
                                            <div class="elementosSeccionPrincipal">
                                                <label id="lblCtrContratoAntiguo" runat="server" for="txtCtrContratoAntiguo" class="lblEtiquetas">Contrato Antiguo</label>
                                                <rfn:RFNTextbox ID="txtCtrContratoAntiguo" runat="server" TipoDato="EnteroPositivo"></rfn:RFNTextbox>
                                            </div>
                                            <div class="elementosSeccionPrincipal">
                                                <label id="lblCtrContratoNuevo" runat="server" for="txtCtrContratoNuevo" class="lblEtiquetas">Contrato Nuevo</label>
                                                <rfn:RFNTextbox ID="txtCtrContratoNuevo" runat="server" TipoDato="EnteroPositivo" MaxLength="10" OnClientChange="ComprobarContrato" ErrorMessage="Código del nuevo contrato obligatorio" ValidationGroup="vGuardaContrato"></rfn:RFNTextbox>
                                            </div>
                                        </div>
                                        <div class="subelementosSeccionPrincipalPadd">
                                            <label id="lblCtrCausaBaja" runat="server" for="ddlCtrCausaBaja" class="lblEtiquetas">Causa de baja</label>
                                            <rfn:RFNDropDownList runat="server" ID="ddlCtrCausaBaja" CausesValidation="True"
                                                ErrorMessage="Causa de Baja Obligatoria" Width="450px" OnClientChange="ActualizaCausaBaja" ValidationGroup="vGuardaContrato"
                                                PermitirVacio="True" Requerido="False" CssClass="control_ddl" Enabled="False"
                                                TextoItemVacio="-- Causas de Baja --">
                                            </rfn:RFNDropDownList>
                                        </div>
                                        <div class="subelementosSeccionPrincipalPadd">
                                            <label id="lblCtrObservBaja" runat="server" for="txtCtrObservBaja" class="lblEtiquetas">Observaciones de baja</label>
                                            <rfn:RFNTextbox runat="server" ID="txtCtrObservBaja" CausesValidation="False" Requerido="False"
                                                ErrorMessage="Observaciones de Baja Obligatoria" ValidationGroup="vGuardaContrato"
                                                Enabled="False" CssClass="control_txt" TextMode="MultiLine" TipoDato="Texto"
                                                Width="500px" MaxLength="200" Height="50px">
                                            </rfn:RFNTextbox>
                                        </div>


                                        <div class="subelementosSeccionPrincipalPadd">
                                            <fieldset id="fsCtrRenoPrecios" class="seccionesPrincipales">
                                                <legend>
                                                    <label id="lblLegendCtrRenoPrecios" runat="server">Renovación de Precios de Concierto</label>
                                                </legend>
                                                <div class="subelementosSeccionPrincipal">
                                                    <div class="elementosSeccionPrincipalCent">
                                                        <label id="lblFecUltReno" runat="server" for="calFecUltReno" class="lblEtiquetas">Fecha de última Renovación</label>
                                                        <rfn:RFNCalendar ID="calFecUltReno" runat="server" Width="75px" Enabled="True"></rfn:RFNCalendar>
                                                    </div>
                                                    <div class="elementosSeccionPrincipal">
                                                        <label id="lblFecFin" runat="server" for="calFecFin" class="lblEtiquetas">Fecha Finalización</label>
                                                        <rfn:RFNCalendar ID="calFecFin" runat="server" Width="75px" Enabled="True"></rfn:RFNCalendar>
                                                    </div>
                                                </div>
                                            </fieldset>
                                        </div>
                                    </div>
                                </fieldset>
                            </rfn:RFNPanel>

                            <%--para la baja multiple de contratos AAEE--%>
                            <div id="DBajaMultiple" runat="server" style="display: none">
                                <rfn:RFNPanel ID="grupoCtrBaja2" runat="server" EstiloContenedor="False" Titulo="Baja Multiple de Contratos AAEE"
                                    Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                    <fieldset id="fsCtrBaja2" class="seccionesPrincipales">
                                        <legend>
                                            <label id="lblLegendCtrBaja2" runat="server">Baja del Contrato</label>
                                        </legend>
                                        <div class="subelementosSeccionPrincipalPadd2">
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <div id="contenedorCtrFecBaja2" runat="server" class="elementosSeccionPrincipal">
                                                    <label id="lblCtrFecBaja2" runat="server" class="lblEtiquetas" style="width: 75px; pointer-events: none; opacity: 0.6: True">Causa de baja</label>
                                                    <rfn:RFNCalendar ID="calCtrFecBaja2" runat="server" ErrorMessage="Fecha de Baja Obligatoria"
                                                        Enabled="True" Requerido="true"
                                                        Width="75px">
                                                    </rfn:RFNCalendar>
                                                </div>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <label id="lblCtrCausaBaja2" runat="server" for="ddlCtrCausaBaja2" class="lblEtiquetas">Causa de baja</label>
                                                <rfn:RFNDropDownList runat="server" ID="ddlCtrCausaBaja2" CausesValidation="True"
                                                    ErrorMessage="Causa de Baja Obligatoria" Width="450px"
                                                    PermitirVacio="True" Requerido="True" CssClass="control_ddl" Enabled="True"
                                                    TextoItemVacio="-- Causas de Baja --">
                                                </rfn:RFNDropDownList>
                                            </div>
                                            <div class="subelementosSeccionPrincipalPadd">
                                                <label id="lblCtrObservBaja2" runat="server" for="txtCtrObservBaja2" class="lblEtiquetas">Observaciones de baja</label>
                                                <rfn:RFNTextbox runat="server" ID="txtCtrObservBaja2" CausesValidation="False" Requerido="True"
                                                    ErrorMessage="Observaciones de Baja Obligatoria"
                                                    Enabled="True" CssClass="control_txt" TextMode="MultiLine" TipoDato="Texto"
                                                    Width="500px" MaxLength="200" Height="50px">
                                                </rfn:RFNTextbox>
                                            </div>
                                            <%--txtCtrBajaMultiple--%>

                                            <div id="DivBajaMultiple" class="subelementosSeccionPrincipalPadd" runat="server">
                                                <label id="lblCtrBajaMultiple" runat="server" for="txtCtrBajaMultiple" class="lblEtiquetas">Observaciones de baja</label>
                                                <rfn:RFNTextbox runat="server" ID="txtCtrBajaMultiple" CausesValidation="False" Requerido="True"
                                                    ErrorMessage="Error en contratos"
                                                    Enabled="True" CssClass="control_txt" TextMode="MultiLine" TipoDato="Texto"
                                                    Width="800px" MaxLength="5000" Height="100px">
                                                </rfn:RFNTextbox>
                                            </div>


                                            <div id="bajamultiple" runat="server" class="elementosSeccionPrincipalCercano" style="display: block">
                                                <label id="lblbajamultiple" runat="server" style="border-color: Black; border-width: 1px; background-color: #009900; color: White; width: 175px; pointer-events: none; opacity: 0.6">Dar de baja contratos AAEE</label>
                                            </div>
                                            <div style="display: none">
                                                <rfn:RFNButton ID="btnBajaMultiple" runat="server" CausesValidation="False" ScriptEnabled="True" />
                                            </div>



                                        </div>

                                    </fieldset>
                                </rfn:RFNPanel>
                            </div>





                            <rfn:RFNPanel ID="grupoFACE" runat="server" EstiloContenedor="False" Titulo="Datos Organismos Públicos"
                                Visualizacion="Seccion" Collapsable="True" Collapsed="True" Width="100%" Display="table">
                                <fieldset id="Fieldset1" class="seccionesPrincipales">
                                    <legend>
                                        <label id="RFNLabel1" runat="server">Datos Organismos Públicos</label>
                                    </legend>
                                    <div class="subelementosSeccionPrincipalPadd2">
                                        <div class="subelementosSeccionPrincipalPadd">
                                            <div style="height: 30px">
                                                <rfn:RFNCheckBox ID="chkDatosFACE" runat="server" Text="Datos FACE" Font-Bold="False"
                                                    OnClientClick="cambioChkDatosFace"></rfn:RFNCheckBox>
                                            </div>
                                            <div runat="server" id="divSeres" style="display: none">
                                                <div>
                                                    <rfn:RFNRadioButtonList ID="rdSeres" runat="server" CellPadding="0" CellSpacing="0"
                                                        RepeatDirection="Horizontal" Requerido="true" CausesValidation="True" OnClientChange="EnvioSeres">
                                                        <asp:ListItem Selected="True" Text="Seres Automático" Value="1" Enabled="true"></asp:ListItem>
                                                        <asp:ListItem Text="Seres Manual" Value="2" Enabled="true"></asp:ListItem>
                                                        <asp:ListItem Text="OB10" Value="3" Enabled="true"></asp:ListItem>
                                                        <asp:ListItem Text="Otros" Value="4" Enabled="true"></asp:ListItem>

                                                    </rfn:RFNRadioButtonList>
                                                </div>
                                                <br />
                                                <div>
                                                    <rfn:RFNRadioButtonList ID="rdfirmaxml" runat="server" CellPadding="0" CellSpacing="0"
                                                        RepeatDirection="Horizontal" Requerido="true" CausesValidation="True">
                                                        <asp:ListItem Selected="True" Text="XML Firmado SI" Value="S" Enabled="true"></asp:ListItem>
                                                        <asp:ListItem Text="XML Firmado NO" Value="N" Enabled="true"></asp:ListItem>


                                                    </rfn:RFNRadioButtonList>
                                                </div>

                                            </div>



                                            <table style="width: 100%;">
                                                <tr>
                                                    <td style="width: 50%;">


                                                        <%--  <div style="height: 30px">
                                                    <rfn:RFNCheckBox ID="chkDatosFACE" runat="server" Text="Datos FACE" Font-Bold="False"
                                                        OnClientClick="cambioChkDatosFace"></rfn:RFNCheckBox>
                                                </div>--%>
                                                        <label id="lblOficinaContable" runat="server" for="txtOficinaContable" class="lblEtiquetas">Oficina Contable</label>
                                                        <rfn:RFNTextbox ID="txtOficinaContable" runat="server" Width="90%" Height="30px"
                                                            Requerido="False" MaxLength="250" TextMode="MultiLine" />
                                                        <%--  OnClientChange ="VALIDAFACE1" CausesValidation="True" ValidationGroup="vGuardaContrato" ErrorMessage="Error en 'Oficina Contable' en los Datos de Organismos Públicos" /> --%>
                                                    </td>
                                                    <td style="width: 50%;">

                                                        <label id="lblUnidadTramitadora" runat="server" for="txtUnidadTramitadora" class="lblEtiquetas">Unidad Tramitadora</label>
                                                        <rfn:RFNTextbox ID="txtUnidadTramitadora" runat="server" Width="90%" Height="30px"
                                                            Requerido="False" MaxLength="250" TextMode="MultiLine" />
                                                        <%-- OnClientChange ="VALIDAFACE2"CausesValidation="True" ValidationGroup="vGuardaContrato" ErrorMessage="Error en 'Unidad Tramitadora' en los Datos de Organismos Públicos" /> --%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50%;">
                                                        <label id="lblOrganoGestor" runat="server" for="txtOrganoGestor" class="lblEtiquetas">Órgano Gestor</label>
                                                        <rfn:RFNTextbox ID="txtOrganoGestor" runat="server" Width="90%" Height="30px" Requerido="False"
                                                            MaxLength="250" TextMode="MultiLine" />
                                                        <%-- OnClientChange ="VALIDAFACE3" CausesValidation="True" ValidationGroup="vGuardaContrato" ErrorMessage="Error en 'Órgano Gestor' en los Datos de Organismos Públicos" /> --%>
                                                    </td>
                                                    <td style="width: 50%;">
                                                        <label id="lblOrganoProponente" runat="server" for="txtOrganoProponente" class="lblEtiquetas">Órgano Competente</label>
                                                        <rfn:RFNTextbox ID="txtOrganoProponente" runat="server" Width="90%" Height="30px"
                                                            Requerido="False" MaxLength="250" TextMode="MultiLine" />
                                                        <%--  OnClientChange ="VALIDAFACE4" CausesValidation="True" ValidationGroup="vGuardaContrato" ErrorMessage="Error en 'Órgano Proponente' en los Datos de Organismos Públicos" /> --%>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </fieldset>
                            </rfn:RFNPanel>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
