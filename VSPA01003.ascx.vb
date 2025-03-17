Imports System.Data
Imports System.Drawing
Imports System.Globalization
Imports System.IO
Imports System.IO.Compression
Imports Arq.ClasesBase.Negocio
Imports Arq.ControladorWeb
Imports Arq.ControlesWeb
Imports Arq.Core.Negocio
Imports Contratacion.Comun
Imports Contratacion.Comun.Datos
Imports Contratacion.Comun.Negocio
Imports Contratacion.Comun.Negocio.Utils
Imports Contratacion.Comun.Negocio.Utils.EnumComun
Imports Contratacion.Contrato.Web.My.Resources
Imports Contratacion.Informes
Imports Microsoft.ApplicationInsights
Imports Microsoft.ApplicationInsights.DataContracts
Imports Microsoft.ApplicationInsights.Extensibility
Imports B = DocumentFormat.OpenXml.Packaging

''' <summary>
''' Formulario de Alta de Contratos
''' </summary>
''' <remarks></remarks>
Partial Class Paginas_VSPA01003
    Inherits PaginaBase

#Region "Constantes"
    Private Const CODIFICACION_EXCEL As String = "ISO-8859-1"
    Dim tc As New TelemetryClient With {
                     .InstrumentationKey = TelemetryConfiguration.Active.InstrumentationKey
                                      }

    Private ReadOnly DOCUMENTO_CONTRATO As String = "5015"
    Private ReadOnly FIRMA_PENDIENTE As String = "Pendiente"
    Private ReadOnly FIRMA_PARCIAL As String = "Firmado parcial"
    Private ReadOnly FIRMA_COMPLETA As String = "Firmado"
    Private ReadOnly FIRMA_CANCELADA As String = "Cancelado"
    Private ReadOnly FIRMA_CADUCADA As String = "Caducado"

    Private ReadOnly TEXTO_INFORMACION = "Información"
    Private ReadOnly TEXTO_ERROR = "Error"
    Private ReadOnly TEXTO_FIRMANTE = ", D/Dª NOMBRE_FIRMANTE, con TIPO_DOCUMENTO IDENTIFICADOR en calidad de CARGO NOTARIO"
    Private ReadOnly TEXTO_FIRMANTE2 = ", D/Dª NOMBRE_FIRMANTE, con DNI/NIF IDENTIFICADOR"
    Private ReadOnly TEXTO_NOTARIO = ", según escritura de poder de fecha FECHA, Nº PODER del protocolo del Notario de PROVINCIA/POBLACION, D/Dª. NOM_NOTARIO "
    Private ReadOnly TEXTO_SPA = "SPA"
    Private ReadOnly TEXTO_ESPANA = "ESPAÑA"
    Private ReadOnly TEXTO_ELIMINA_IPC = "No se puede eliminar el IPC porque hay un Anexo posterior o ya se ha eliminado el IPC."
    Private ReadOnly EXPRESION_REGULAR_VERSION_DOCUMENTO = "V\.[0-9]+_?[0-9]+"
    Private ReadOnly TEXTO_PROVINCIAS_ESPECIALES_FIRMANTES = "PROVINCIAS_ESPECIALES_FIRMANTES"
    Private ReadOnly TEXTO_OBLIGATORIO_DOCUMENTO = "Contrato de AAEE sin pdf de presupuesto firmado subido a la documentación del contrato. Puede o subir el pdf o registrar firmantes y generar documento de contrato para poder ponerlo vigente."
    Private ReadOnly ACTIVIDADES_ESPECIFICAS = "Actividades Específicas"
    Private ReadOnly COD_PRUEBA_ABSENTISMOS = "ABS0ABS"
    Private ReadOnly NOMBRE_CARTA_BAJA_1 = "Carta de Baja Contrato "
    Private ReadOnly NOMBRE_CARTA_BAJA_2 = "Solicitud fuera plazo "
    Private ReadOnly NOMBRE_CARTA_BAJA_3 = "Solicitud fuera plazo morosidad "
    Private ReadOnly TEXTO_NOT_FOUND = "El fichero no se encuentra en al archivo documental."
    Private ReadOnly CultureInfoSpain = New CultureInfo("es-ES", False)
    Private ReadOnly TEXTO_CONTRATO_NOT_FOUND = "No existe un nuevo contrato OHS con ese código. El contrato no se guardará."
    Private ReadOnly TEXTO_CONTRATO_NOT_VALIDO = "El nuevo contrato indicado asociado a este que se va a Terminar no se encuentra Vigente. El contrato no se guardará."

    Dim pageName As String = "VSPA01003"

#End Region

#Region "Variables Globales a la Ventana"
    Dim wsContratacion As New WsContratacion.WsContratacion
    Dim cacheContratacion As New Plantillas_PSPA01001
    Dim mensajeGuardar As Boolean = True
    Dim cambiaEstado As Boolean = False
    Dim Activar_Otras_VSI As String
    Dim TipoPresupuesto As String

#End Region

#Region "Eventos de menu"

    Protected Sub tlbCtrBarraPrincipal_MenuItemClick(sender As Object, e As System.Web.UI.WebControls.MenuEventArgs) Handles tlbCtrBarraPrincipal.MenuItemClick
        If e.Item.Value = "Contactos" Then
            ConsultaContactos()
        End If
    End Sub

    ''' <summary>
    ''' Navega a la ventana de consulta de contactos.
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ConsultaContactos()

        Dim pagina As String
        Dim parametros As ParametrosPaginaBase = New ParametrosPaginaBase()

        Dim direccioncontactos As String = AppConfiguration.GetKeyValue("URL_CONTACTOS")
        direccioncontactos = MetodosAux.EliminarParametros(direccioncontactos)

        direccioncontactos = MetodosAux.ObtenerValorClaveValorArquitectura("URL_CONTACTOS", TEXTO_SPA)

        parametros("clientetipo") = "E"
        parametros("clienteid") = ccdRazonSocial1.Codigo
        parametros("provincia") = ""

        pagina = "VSPA03002"

        Dim script As String = "Sys.Application.add_load(function(){arq_gestor.abrirVentana('" & GetEnlaceCliente(direccioncontactos, pagina, parametros) & "');});"

        ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "navegar", script, True)


    End Sub

#End Region

#Region "Eventos de la página"

    Private Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init
    End Sub

    Public Function NombreCompleto(nombreLogin As String) As String
        Dim cadenaNombreCompleto As String = Session.Item("Persona.NombreCompleto")
        If cadenaNombreCompleto Is Nothing Then
            Dim contratosWebServiceAjax As ContratosWebServiceAjax = New ContratosWebServiceAjax()
            Dim nombre As String = contratosWebServiceAjax.NombreCompletoPersona(nombreLogin)

            Session.Item("Persona.NombreCompleto") = nombre
            cadenaNombreCompleto = nombre
        End If
        Return cadenaNombreCompleto
    End Function

    ''' <summary>
    ''' Inicializamos los controlesweb que forman la página
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Me.AdminScripts.Services.Add(New ServiceReference("~/WebServices/ContratosWebServiceAjax.asmx"))
            Me.AdminScripts.Services.Add(New ServiceReference("~/WebServices/DocumentsWebServiceAjax.asmx"))
            Me.AdminScripts.Services.Add(New ServiceReference("~/WebServices/AnexosWebServiceAjax.asmx"))
            Dim Anexo_tarifa = ConstanteDatos.DameCte("A_ANEXO_TARIFA", TEXTO_SPA, tc)
            hfModColab.Value = ColaboradoresDatos.ObtenerPerfilesColaboradores(Usuario.Login.ToUpper(CultureInfoSpain), tc)
            hfModCuenta.Value = DamePerfilesUsuario(Usuario.Login.ToUpper(CultureInfoSpain))
            Dim Activar_Otras_VSI = ConstanteDatos.DameCte("A_PRUEBAS_VSI", TEXTO_SPA, tc)
            Dim Activar_ANEXO_AAEE = ConstanteDatos.DameCte("A_ANEXO_AAEE", TEXTO_SPA, tc)
            Dim Activar_SERES = ConstanteDatos.DameCte("A_SERES", TEXTO_SPA, tc)
            Dim Activar_Cif_pagador = ConstanteDatos.DameCte("A_CIF_PAGADOR", TEXTO_SPA, tc)
            hfA_FormulaHorasSHE.Value = ConstanteDatos.DameCte("A_FormulaHorasSHE", TEXTO_SPA, tc)
            Dim Activar_ANEXO_BH = ConstanteDatos.DameCte("A_ANEXO_BH", TEXTO_SPA, tc)
            Dim AUTONORENOVABLE = ConstanteDatos.DameCte("A_AUTO_RENOV", TEXTO_SPA, tc)
            Dim ActivarExcel = ConstanteDatos.DameCte("A_EXCEL_CONTRATO", TEXTO_SPA, tc)
            Dim ActivarDireccionParti = ConstanteDatos.DameCte("A_DIRE_PARTI", TEXTO_SPA, tc)
            Dim MAXNUMCENTROS = Constante.ObtenerValor("NUM_CENTROS_CONTRATO", TEXTO_SPA)
            hfCodColaborIESA.Value = ConstanteDatos.DameCte("COD_COLABOR_IESA", TEXTO_SPA, tc)
            hfCodTarifaPermitida.Value = ConstanteDatos.DameCte("CAMBIO_COD_TARIFA", TEXTO_SPA, tc)
            hfHabilitaDatosSociales.Value = Constante.ObtenerValor("TARIFA_NO_ANEXO", TEXTO_SPA)
            hfProvinciasEspecialesFirmantes.Value = ConstanteDatos.DameCte(TEXTO_PROVINCIAS_ESPECIALES_FIRMANTES, TEXTO_SPA, tc)


            Dim scriptManager As ScriptManager = ScriptManager.GetCurrent(Page)
            scriptManager.RegisterPostBackControl(gvCtrDatosFicherosDigital)

            grupoOtrasActividades.Style.Add("display", "none")

            hfPrecioHoraSHE.Value = CDbl(Constante.ObtenerValor("PrecioHoraSHE", TEXTO_SPA))
            hfDesfaseHorasSHE.Value = CDbl(Constante.ObtenerValor("DesfaseHorasSHE", TEXTO_SPA))

            hfpermisoColab.Value = PermisoFuncionalidad(Usuario.Login, "COLABORADOR")
            hfpermisoBajaFilial.Value = PermisoFuncionalidad(Usuario.Login, "ANULAR_FILIALES")
            hfpermisoFecFirma.Value = PermisoFuncionalidad(Usuario.Login, "FEC_FIRMA")
            hfpermisoTarifa.Value = PermisoFuncionalidad(Usuario.Login, "TARIFA")
            hfpermisoDireCentro.Value = PermisoFuncionalidad(Usuario.Login, "ACT_DIRE_CENTRO")
            hfpermisoFactLibre_IESA.Value = PermisoFuncionalidad(Usuario.Login, "ACT_FACTLIBRE_IESA")

            If ActivarDireccionParti = "N" Then
                factparti.Style.Add("display", "none")
            Else
                hffactparti.Value = "S"
            End If

            If ActivarExcel = "N" Then
                divdescargacentros.Style.Add("display", "none")
            End If
            If Activar_Cif_pagador = "N" Then
                divActivarCifPagador.Style.Add("display", "none")
            End If

            If Activar_SERES = "S" Then
                divSeres.Style.Add("display", "block")
            End If

            hfAnexotarifa.Value = Anexo_tarifa
            hfOtrasVsi.Value = Activar_Otras_VSI
            hfActivarAnexoAAEE.Value = Activar_ANEXO_AAEE
            hfActivarAnexoBH.Value = Activar_ANEXO_BH

            If hfModCuenta.Value = 1 Then
                lblfact.Style.Add("display", "block")
                txtIban.Enabled = False
            End If

            txtControlCaracteresConCalleDS.Style.Add("display", "none")
            txtControlCaracteresDS.Style.Add("display", "none")
            txtControlCaracteresConCalleEnvFact.Style.Add("display", "none")
            txtControlCaracteresEnvFact.Style.Add("display", "none")

            divSuspendido.Style.Add("display", "none")

            chkCarteraNegociada.Style.Add("display", "none")
            calFecIniFact.Style.Add("display", "none")

            Me.AddLoadScript("cambioTextoNotario1();")

            txtContratoSAP.Text = Parametro("contratoSAP")

            If Parametro("indEspecificas") = "S" AndAlso Parametro("indAutonomo") = "N" AndAlso Parametro("indBolsaHoras") = "N" Then
                lblCodContratoAsociado.Style.Add("display", "block")
                txtCodContratoAsociado.Style.Add("display", "block")
                RFNchkRenovable.Style.Add("display", "block")

            Else
                lblCodContratoAsociado.Style.Add("display", "none")
                txtCodContratoAsociado.Style.Add("display", "none")
                RFNchkRenovable.Style.Add("display", "none")

                If Parametro("indAutonomo") = "S" Then
                    If AUTONORENOVABLE = "S" Then
                        RFNchkRenovable.Style.Add("display", "block")
                        hfautonomo.Value = "S"
                    Else

                        RFNchkRenovable.Style.Add("display", "none")
                        hfautonomo.Value = "N"
                    End If
                Else
                    If Parametro("indBolsaHoras") = "S" Then
                        RFNchkRenovable.Style.Add("display", "block")

                    End If

                End If
            End If

            If Parametro("indEspecificas") = "N" AndAlso Parametro("indAutonomo") = "N" AndAlso Parametro("indBolsaHoras") = "N" Then
                chkSinCentro.Style.Add("display", "block")
            End If

            hfGestionInterna.Value = Constante.ObtenerValor("GESTION_INTERNA", TEXTO_SPA).ToString(CultureInfoSpain)

            Dim ID_TARIFA_BAYES As Integer

            ID_TARIFA_BAYES = Constante.ObtenerValor("ID_TARIFA_BAYES", TEXTO_SPA).ToString(CultureInfoSpain)

            If Parametro("tarifa") = "" Then
                Parametro("tarifa") = 0
            End If

            If ID_TARIFA_BAYES = Parametro("tarifa") Then
                hfidtarifabayes.Value = "S"
            Else
                hfidtarifabayes.Value = "N"
            End If

            hftarifa.Value = Parametro("tarifa")

            ProxyGridViews()

            cacheContratacion = Me.PaginaPadre

            hfNomLogin.Value = Usuario.Login.Trim

            If Not Me.EsPostBack Then

                If Not String.IsNullOrEmpty(Parametro("idContrato")) Then

                    Me.gvCursosFormacion.AutoLoad = True

                    txtIdPresupuesto.Text = Parametro("idPresupuesto")
                    txtCtrCodPresupuesto.Text = Parametro("codPresupuesto")
                    txtCtrCodPresupuestoFirma.Text = Parametro("codPresupuesto")

                    txtCtrIdContrato.Text = Parametro("idContrato")
                    txtCtrCodContrato.Text = Parametro("codContrato")
                    txtCtrCodContratoFirma.Text = Parametro("codContrato")

                    hfidCliente.Value = Parametro("idCliente")

                    If Not String.IsNullOrEmpty(Parametro("idContrato")) Then
                        TieneElPresupProductosPruebasVSI(Parametro("idContrato"))
                    End If

                End If
            Else

                Dim ctrlname As String = Page.Request.Params.Get("__EVENTTARGET")

                If ctrlname IsNot Nothing AndAlso String.Compare(ctrlname, "recargar", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                    ReiniciarDropDownListEstadoContrato()
                End If

            End If

            lblfltroCT.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            lblfltroCT.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            lblfltroCT.Attributes.Add("onclick", "filtroCT();")

            lbllimpiarfiltroct.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            lbllimpiarfiltroct.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            lbllimpiarfiltroct.Attributes.Add("onclick", "LimpiarfiltroCT();")



            lblGrabarDomiSocial.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            lblGrabarDomiSocial.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            lblGrabarDomiSocial.Attributes.Add("onclick", "grabarDomiSocial();")

            lblSubeDocumento.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            lblSubeDocumento.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            lblSubeDocumento.Attributes.Add("onclick", "cargarDocumento();")

            imgCtrCierrepopUpHistDocumento.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
            imgCtrCierrepopUpHistDocumento.Attributes.Add("onclick", "histCtrDocumento();")
            imgCtrCierrepopUpHistDocumento.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/aceptar.gif"

            imgCtrCierrepopUpCartaBaja.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
            imgCtrCierrepopUpCartaBaja.Attributes.Add("onclick", "ContrtolCartaBaja();")
            imgCtrCierrepopUpCartaBaja.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/aceptar.gif"

            btnCtrMostrarVersionDocumento.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            btnCtrMostrarVersionDocumento.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            btnCtrMostrarVersionDocumento.Attributes.Add("onclick", "histCtrDocumento();")

            btnMostrarCartasBaja.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            btnMostrarCartasBaja.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            btnMostrarCartasBaja.Attributes.Add("onclick", "ContrtolCartaBaja();")

            btnoMbservaciones.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            btnoMbservaciones.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            btnoMbservaciones.Attributes.Add("onclick", "modal_observaciones();")
            btnMActividades.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            btnMActividades.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            btnMActividades.Attributes.Add("onclick", "VerActividades();")

            btnDescargarExcel.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
            btnDescargarExcel.Attributes.Add("onclick", "descargaExcel();")

            txtCtrVersionDocumento.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
            txtCtrVersionDocumento.Attributes.Add("onmouseout", "this.style.fontWeight='';")
            txtCtrVersionDocumento.Attributes.Add("onclick", "histCtrDocumento();")

            EventosJavaScript()
            CargaControlesGenerales()
            ObtenerProductoEspecialMedicina()

            Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))

            estadoDocumento.Style.Add("display", "block")
            espacioEstadoDocumento.Style.Add("display", "none")

            GetDocuments(detallesContrato)

            TipoPresupuesto = EsPreupuestoQS(txtCtrCodContrato.Text)
            If Parametro("presupuestoTebex") = "S" OrElse TipoPresupuesto = 2 OrElse TipoPresupuesto = "2" Then
                CargaPlazoPagoTebex()
            End If

            hfGestionDirecta.Value = Constante.ObtenerValor("GESTION_DIRECTA", TEXTO_SPA)
            hfPrecioFirmantes.Value = Constante.ObtenerValor("PRECIO_FIRMANTES", TEXTO_SPA)

            If Not String.IsNullOrEmpty(txtCtrIdContrato.Text) Then

                Dim wsContrato As New WsContratacion.WsContratacion
                Dim dtListaColaboradores As New DataTable
                Dim iIdContrato As Integer = 0
                Dim dtListaTarifas As New DataTable

                Integer.TryParse(txtCtrIdContrato.Text, iIdContrato)

                dtListaTarifas = descomprimirDataset(Comun.Datos.ContratoDatos.BuscaListaHistoricoTarifas(iIdContrato, Usuario.Login)).Tables(0)

                If dtListaTarifas IsNot Nothing AndAlso dtListaTarifas.Rows.Count > 0 Then
                    gvHistTarifa.DataSource = dtListaTarifas
                    gvHistTarifa.DataBind()
                End If

                dtListaColaboradores = descomprimirDataset(wsContrato.BuscaListaColaboradoresPorIdContrato(iIdContrato, Usuario.Login)).Tables(0)

                If dtListaColaboradores IsNot Nothing AndAlso dtListaColaboradores.Rows.Count > 0 Then

                    dtListaColaboradores.Columns.Add("SEM_PORCENTAJE")

                    For Each rowColaborador As DataRow In dtListaColaboradores.Rows

                        Dim fechaVinculacion As New Date
                        Dim anyoVinculacion As Integer = 0
                        Dim mesVinculacion As Integer = 0

                        Date.TryParse(rowColaborador("FEC_VINCULACION").ToString, fechaVinculacion)

                        anyoVinculacion = fechaVinculacion.Year
                        mesVinculacion = fechaVinculacion.Month


                        Dim fechaReferencia As New Date(2009, 7, 1)
                        If Date.Compare(fechaReferencia, fechaVinculacion) <> -1 Then

                            If mesVinculacion < 7 Then
                                rowColaborador("SEM_PORCENTAJE") = String.Concat("1º-", anyoVinculacion.ToString(CultureInfoSpain))
                            Else
                                rowColaborador("SEM_PORCENTAJE") = String.Concat("2º-", anyoVinculacion.ToString(CultureInfoSpain))
                            End If

                            gvHistColab.Columns(4).HeaderText = "Sem. Porcentaje"

                        Else

                            If mesVinculacion >= 0 AndAlso mesVinculacion <= 3 Then
                                rowColaborador("SEM_PORCENTAJE") = String.Concat("1º-", anyoVinculacion.ToString(CultureInfoSpain))
                            ElseIf mesVinculacion > 3 AndAlso mesVinculacion <= 6 Then
                                rowColaborador("SEM_PORCENTAJE") = String.Concat("2º-", anyoVinculacion.ToString(CultureInfoSpain))
                            ElseIf mesVinculacion > 6 AndAlso mesVinculacion <= 9 Then
                                rowColaborador("SEM_PORCENTAJE") = String.Concat("3º-", anyoVinculacion.ToString(CultureInfoSpain))
                            ElseIf mesVinculacion > 9 Then
                                rowColaborador("SEM_PORCENTAJE") = String.Concat("4º-", anyoVinculacion.ToString(CultureInfoSpain))
                            End If

                            gvHistColab.Columns(4).HeaderText = "Trim. Porcentaje"

                        End If

                    Next

                    gvHistColab.DataSource = dtListaColaboradores
                    gvHistColab.DataBind()

                End If

            End If

            ConfiguracionContratoMigradoOno()
            CargarObservacionesIniciales()

            Dim VALGE As Integer
            VALGE = UsuarioDatos.ValidaUsuarioGE(Usuario.Login.ToUpper(CultureInfoSpain), tc)

            If VALGE = 1 Then
                chkCaptacionAAEE.Enabled = True
            Else
                chkCaptacionAAEE.Enabled = False
            End If

            Dim activarGgcc As String = Constante.ObtenerValor("ACT_GGCC", TEXTO_SPA).ToString(CultureInfoSpain)

            If activarGgcc = "S" Then
                If VALGE = 1 Then
                    chkCaptacionAAEE.Enabled = True
                Else
                    chkCaptacionAAEE.Enabled = False
                End If

            Else
                chkCaptacionAAEE.Enabled = True
            End If

            Me.AddLoadScript("OcultarRecos();")

            Dim MODCOMISION As Integer
            MODCOMISION = ColaboradoresDatos.ObtenerPerfilesColaboradores(Usuario.Login.ToString(CultureInfoSpain), tc)

            If MODCOMISION = 1 Then
                Me.AddLoadScript("HabiComision();")
            Else
                Me.AddLoadScript("IHabiComision();")
            End If

            txtcenttotal.Text = ContratoDatos.DameNumeroCentros(CInt(txtCtrIdContrato.Text), tc)
            hfCentContrato.Value = txtcenttotal.Text
            hfNumMaxCentros.Value = MAXNUMCENTROS

            If hfOtrasVsi.Value = "S" Then
                Dim wsContratacion As New WsContratacion.WsContratacion
                Dim dtRecosVSI As New DataTable
                Dim iIdContrato As Integer = 0

                Integer.TryParse(txtCtrIdContrato.Text, iIdContrato)

                dtRecosVSI = descomprimirDataset(wsContratacion.ObtenerRecosVSIContratoPorId(iIdContrato, Usuario.Login)).Tables(0)

                If dtRecosVSI.Rows.Count > 0 Then
                    For Each reconocimientoVSI As DataRow In dtRecosVSI.Rows
                        If reconocimientoVSI("COD_PRUEBA").ToString.Trim() = "RECOBR" Then
                            txtTarifaBR.Text = reconocimientoVSI("IMP_TARIFA").ToString.Trim()
                            txtDesdeBR1.Text = reconocimientoVSI("CANT_TRAMO_1").ToString.Trim()
                            txtPrecioBR1.Text = reconocimientoVSI("IMP_TRAMO_1").ToString.Trim()
                            txtDesdeBR2.Text = reconocimientoVSI("CANT_TRAMO_2").ToString.Trim()
                            txtPrecioBR2.Text = reconocimientoVSI("IMP_TRAMO_2").ToString.Trim()
                            txtDesdeBR3.Text = reconocimientoVSI("CANT_TRAMO_3").ToString.Trim()
                            txtPrecioBR3.Text = reconocimientoVSI("IMP_TRAMO_3").ToString.Trim()
                            txtDesdeBR4.Text = reconocimientoVSI("CANT_TRAMO_4").ToString.Trim()
                            txtPrecioBR4.Text = reconocimientoVSI("IMP_TRAMO_4").ToString.Trim()

                        End If
                        If reconocimientoVSI("COD_PRUEBA").ToString.Trim() = "RECOAR" Then
                            txtTarifaAR.Text = reconocimientoVSI("IMP_TARIFA").ToString.Trim()
                            txtDesdeAR1.Text = reconocimientoVSI("CANT_TRAMO_1").ToString.Trim()
                            txtPrecioAR1.Text = reconocimientoVSI("IMP_TRAMO_1").ToString.Trim()
                            txtDesdeAR2.Text = reconocimientoVSI("CANT_TRAMO_2").ToString.Trim()
                            txtPrecioAR2.Text = reconocimientoVSI("IMP_TRAMO_2").ToString.Trim()
                            txtDesdeAR3.Text = reconocimientoVSI("CANT_TRAMO_3").ToString.Trim()
                            txtPrecioAR3.Text = reconocimientoVSI("IMP_TRAMO_3").ToString.Trim()
                            txtDesdeAR4.Text = reconocimientoVSI("CANT_TRAMO_4").ToString.Trim()
                            txtPrecioAR4.Text = reconocimientoVSI("IMP_TRAMO_4").ToString.Trim()
                        End If
                    Next
                End If

            End If

            If cacheContratacion.hfEsPerfilDirProvincial.Value = "S" OrElse cacheContratacion.hfEsPerfilDirTerritorial.Value = "S" OrElse cacheContratacion.hfEsPerfilCentral.Value = "S" Then
                chkAAPP.Enabled = True
            Else
                chkAAPP.Enabled = False
            End If

            If txtCtrIdContrato.Text <> "" Then
                TipoPresupuesto = EsPreupuestoQS(txtCtrCodContrato.Text)
                hdnPresupuestoQS.Value = "N"
                hdnPresupuestoTebex.Value = "N"
                hdnPresupuestoQPPortugal.Value = "N"
                hdnPresupuestoMedycsa.Value = "N"
                hdnPresupuestoQPPeru.Value = "N"

                If TipoPresupuesto > 0 Then
                    camposQS.Style.Add("display", "block")
                    datospersonaFilial.Style.Add("display", "block")
                    lblGenerarDocumentacion.Style.Add("display", "none")
                    chkGenerarFirmado.Style.Add("display", "none")
                    chkGenerarFirmaOtp.Style.Add("display", "none")
                End If
                If Parametro("presupuestoQS") = "S" OrElse TipoPresupuesto = 1 Then
                    hdnPresupuestoQS.Value = "S"
                    Me.AddLoadScript("camposRequeridosFiliales();")
                ElseIf Parametro("presupuestoTebex") = "S" OrElse TipoPresupuesto = 2 Then
                    hdnPresupuestoTebex.Value = "S"
                    Me.AddLoadScript("camposRequeridosFiliales();")
                ElseIf Parametro("presupuestoQPPortugal") = "S" OrElse TipoPresupuesto = 3 Then
                    hdnPresupuestoQPPortugal.Value = "S"
                    Me.AddLoadScript("camposRequeridosFiliales();")
                ElseIf Parametro("presupuestoMedycsa") = "S" OrElse TipoPresupuesto = 4 Then
                    hdnPresupuestoMedycsa.Value = "S"
                    observacionesMedycsaContrato.Style.Add("display", "block")
                    Me.AddLoadScript("camposRequeridosFiliales();")
                ElseIf Parametro("presupuestoQPPeru") = "S" OrElse TipoPresupuesto = 5 Then
                    hdnPresupuestoQPPeru.Value = "S"
                    Me.AddLoadScript("camposRequeridosFiliales();")
                End If

                'txtvsitotal.Text = VsiDatos.ObtenerTotalPruebasVsiContrato(txtCtrIdContrato.Text, tc, 0, 0, 0, 0)
                Dim PruebasVsi As Integer = 0
                Dim PruebaABS As Integer = 0
                Dim PruebaRECOM As Integer = 0
                Dim PruebaRegu As Integer = 0
                Dim Estado As Char = ""
                Dim Linea As String = ""
                Dim Medicina As Char = ""

                VsiDatos.ObtenerTotalPruebasVsiContrato(txtCtrIdContrato.Text, tc, PruebasVsi, PruebaABS, PruebaRECOM, PruebaRegu, Estado, Linea, Medicina)
                txtvsitotal.Text = PruebasVsi
                If Linea = "S" AndAlso Medicina = "S" AndAlso (Estado = "C" OrElse Estado = "P" OrElse Estado = "F") AndAlso ddlCtrEstadoContrato.SelectedValue <> "V" _
                                           AndAlso ddlCtrEstadoContrato.SelectedValue <> "A" Then

                    Dim Texto As String = "Contrato de Gran Cuenta sin personalización de precio de Absentismo, Exceso Recos ni Hueco Unidad Móvil."

                    If PruebaABS = 0 AndAlso PruebaRECOM = 0 AndAlso PruebaRegu = 0 Then
                        MostrarMensaje(Texto, "Información")
                    End If

                End If

                If Not Me.EsPostBack Then
                    If CInt(txtvsitotal.Text) > 148 Then
                        Me.AddLoadScript("MostrarAvisoVsi();")
                    End If
                End If
            End If

            AñadirParametrosAOtrasActividades()
            ComprobarCuenta()

        Catch ex As Exception
            Traces.TrackException(ex, tc, pageName, "Error al cargar contrato")
            Me.MostrarMensaje("Error al Cargar la Página VSPA01003, " & ex.ToString)
            Throw
        End Try

    End Sub

    Private Sub Page_PreRender1(sender As Object, e As System.EventArgs) Handles Me.PreRender
        Dim sm As ScriptManager
        sm = ScriptManager.GetCurrent(Page)
        sm.Services.Add(New ServiceReference("~/WebServices/WebServiceContratacion.asmx"))
    End Sub

    ''' <summary>
    ''' Cuando una ventana modal llamada desde esta ventana se cierra viene a esta función.
    ''' </summary>
    ''' <param name="Mensaje"> nombre de la ventana que se ha cerrado.</param>
    ''' <remarks></remarks>
    ''' 
    Protected Sub Page_ModalClose(ByVal Mensaje As String) Handles Me.PaginaHijaCerrada
        'Necesario
    End Sub

#End Region

#Region "Métodos privados"


#Region "Métodos de Llamada al Webservice de Negocio"

    ''' <summary>
    ''' Carga las diferentes Causas de Baja.
    ''' </summary>   
    ''' <returns> Devuelve un Datatable con los datos solicitados</returns>
    ''' <remarks></remarks>
    Private Function dameCausasBaja() As DataTable

        Dim wsContratacion As New WsContratacion.WsContratacion

        Return wsContratacion.ObtenerCausasBajaContrato(Parametro("codContrato"))
    End Function

    ''' <summary>
    ''' Carga los diferentes Estados en los que puede encontrarse el Presupuesto.
    ''' </summary>   
    ''' <returns> Devuelve un Datatable con los datos solicitados</returns>
    ''' <remarks></remarks>
    Private Function dameEstados(ByVal sEntidad As String) As DataTable

        Dim wsContratacion As New WsContratacion.WsContratacion

        Return descomprimirDataset(wsContratacion.ObtenerEstados(sEntidad)).Tables(0)

    End Function

    ''' <summary>
    ''' Carga las diferentes Regiones.
    ''' </summary>   
    ''' <returns> Devuelve un Datatable con los datos solicitados</returns>
    ''' <remarks></remarks>
    Private Function dameRegiones() As DataTable

        Return Session.Item("Provincias")

    End Function

    ''' <summary>
    ''' Carga los diferentes Tipos de Vias.
    ''' </summary>   
    ''' <returns> Devuelve un Datatable con los datos solicitados</returns>
    ''' <remarks></remarks>
    Private Function DameTipoVias() As DataTable

        Return Session.Item("TiposVia")

    End Function

    Private Sub TieneElPresupProductosPruebasVSI(ByVal iIdPresupuesto As Integer)
        Dim erroresTryParse As Boolean = True
        Try

            If (iIdPresupuesto <> 0) Then
                Dim dtNumProductosVIP_Presupuesto As DataTable
                Dim countNumRecosVIP_Presupuesto As Integer

                dtNumProductosVIP_Presupuesto = descomprimirDataset(wsContratacion.ObtenerProductosVipPorIdContrato(iIdPresupuesto, Usuario.Login)).Tables(0)
                erroresTryParse = Integer.TryParse(dtNumProductosVIP_Presupuesto.Rows(0).Item(0).ToString, countNumRecosVIP_Presupuesto)

                hdnTieneElPresupProductosPruebasVSI.Value = "N"

                If countNumRecosVIP_Presupuesto > 0 Then
                    hdnTieneElPresupProductosPruebasVSI.Value = "S"
                End If
            End If
        Catch ex As Exception
            Me.MostrarMensaje(ex.ToString, "Error al gabrar el contrato: Metodo ->TieneElPresupProductosPruebasVSI")
        End Try

    End Sub

#End Region

#Region "Métodos de Carga de Ventana"
    Private Sub ConfiguracionContratoMigradoOno()
        If txtContratoSAP.Text <> "" Then

            hfContratoMigrado.Value = ContratoDatos.EsContratoMigrado(txtCtrCodContrato.Text, tc)

            If hfContratoMigrado.Value = "1" Then
                Rfnchkmigrado.Checked = True
            Else
                DesActAnexo.Value = 1
                chkFactLibreF.Style.Add("display", "none")
                chkFLrec.Style.Add("display", "none")
                chkFLana.Style.Add("display", "none")
                chkFLvsi.Style.Add("display", "none")
                chkFactUniVsi.Style.Add("display", "none")
            End If

        End If

        If txtContratoSAP.Text = "" Then
            Rfnchkmigrado.Style.Add("display", "none")
            rfncalmigrado.Style.Add("display", "none")
            divMigrado.Style.Add("display", "none")
        End If
    End Sub

    Private Sub EventosJavaScript()
        contenedorCtrFecBaja.Attributes.Add("onmouseover", "clickCtrcalFecBaja();")
        contenedorFecDesdeIPC.Attributes.Add("onmouseover", "cambioCtrFecDesdeIPC();")
        contenedorCtrFecFirma.Attributes.Add("onmouseover", "cambioCtrFecFirma();")
        contenedorCtrFecPoderDirectivo1.Attributes.Add("onmouseover", "cambioCtrPoderDirectivo1();")
        contenedorCtrFecPoderDirectivo2.Attributes.Add("onmouseover", "cambioCtrPoderDirectivo2();")
        contenedorCtrFecColabDesde.Attributes.Add("onmouseover", "cambioCtrFecColabDesde();")
        contenedorCtrFecEstadoContrato.Attributes.Add("onmouseover", "cambioCtrFecEstadoContrato();")

        btnrecargar.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        btnrecargar.Attributes.Add("onmouseout", "this.style.fontWeight='';")
        btnrecargar.Attributes.Add("onclick", "RecargarPruebasVsi();")

        lblhistTarifa.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblhistTarifa.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblhistTarifa.Attributes.Add("onclick", "histTarifa();")

        btnCtrEliminaRepresentante.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnCtrInsertaRepresentante.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnCtrEliminaRepresentante.Attributes.Add("onclick", "ocultarCtrRepresentante();")
        btnCtrInsertaRepresentante.Attributes.Add("onclick", "mostrarCtrRepresentante();")
        btnCtrEliminaRepresentante.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/eliminar_grid.png"
        btnCtrInsertaRepresentante.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/anyadir_grid.png"

        btnCtrEliminaDirectivo.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnCtrInsertaDirectivo.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnCtrEliminaDirectivo.Attributes.Add("onclick", "ocultarCtrDirectivo();")
        btnCtrInsertaDirectivo.Attributes.Add("onclick", "mostrarCtrDirectivo();")
        btnCtrEliminaDirectivo.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/eliminar_grid.png"
        btnCtrInsertaDirectivo.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/anyadir_grid.png"

        imgCierrepopUpCentros.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        imgCierrepopUpCentros.Attributes.Add("onclick", "detalleCentros();")
        imgCierrepopUpCentros.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/aceptar.gif"

        imgCierrepopUpAnexoRenovacion.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        imgCierrepopUpAnexoRenovacion.Attributes.Add("onclick", "cerrarAnexoRenovacion();")
        imgCierrepopUpAnexoRenovacion.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/eliminar_grid.png"

        imgGuardarpopUpAnexoRenovacion.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        imgGuardarpopUpAnexoRenovacion.Attributes.Add("onclick", "guardarAnexoRenovacion();")
        imgGuardarpopUpAnexoRenovacion.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/guardar_grid.png"

        btnInsertaAnaliticaPerfil.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnInsertaAnaliticaPerfil.Attributes.Add("onclick", "InsertaAnaliticaPerfil();")
        btnInsertaAnaliticaPerfil.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/anyadir_grid.png"

        btnInsertaAnaliticaSimple.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnInsertaAnaliticaSimple.Attributes.Add("onclick", "InsertaAnaliticaSimple();")
        btnInsertaAnaliticaSimple.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/anyadir_grid.png"

        btnInsertaAnaliticaCompuesta.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        btnInsertaAnaliticaCompuesta.Attributes.Add("onclick", "InsertaAnaliticaCompuesta();")
        btnInsertaAnaliticaCompuesta.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/grid/anyadir_grid.png"

        imgDetalleFactCentro.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        imgDetalleFactCentro.Attributes.Add("onclick", "detalleCentros();")

        imgCierrepopUpDesdeContrato.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        imgCierrepopUpDesdeContrato.Attributes.Add("onclick", "desdeContrato();")
        imgCierrepopUpDesdeContrato.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/aceptar.gif"

        imgCierrepopUpHistColab.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        imgCierrepopUpHistColab.Attributes.Add("onclick", "histColab();")
        imgCierrepopUpHistColab.ImageUrl = ConfArq.Instance.Repositorio & "/controles/temas/ddae/imgs/aceptar.gif"

        lblDesdeContrato.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblDesdeContrato.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblDesdeContrato.Attributes.Add("onclick", "desdeContrato();")

        lblHistColab.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblHistColab.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblHistColab.Attributes.Add("onclick", "histColab();")

        contenedorFecDesdeIPC.Attributes.Add("onmouseover", "cambioFecDesdeIPC();")

        txtCtrCodPresupuesto.Attributes.Add("onmouseover", "this.style.cursor='pointer';")
        txtCtrCodPresupuesto.Attributes.Add("onclick", "NavegarPresupuesto();")

        txtCtrIdentificadorRepresentante1.Attributes.Add("onchange", "cambioRepresentante1();")
        txtCtrIdentificadorRepresentante2.Attributes.Add("onblur", "cambioRepresentante2();")

        btnMigrarDatosContrato.Attributes.Add("onclick", "MigraDatosContrato();")

        lblCrearAnexo.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='';")
        lblCrearAnexo.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")

        lblCrearAnexo.Attributes.Add("onclick", "altaAnexo();")


        lblCrearAnexoAAEE.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='';")
        lblCrearAnexoAAEE.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")

        lblCrearAnexoAAEE.Attributes.Add("onclick", "altaAnexoAAEE();")

        lblCrearAnexoAnalitica.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='';")
        lblCrearAnexoAnalitica.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")

        lblgrabarcentro.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='';")
        lblgrabarcentro.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")

        lblgrabarcentro.Attributes.Add("onclick", "ModificarCentro();")

        lblCrearAnexoRenovacion.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='';")
        lblCrearAnexoRenovacion.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")

        lblCrearAnexoRenovacion.Attributes.Add("onclick", "altaAnexoRenovacion();")

        lblGenerarDocumentacion.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblGenerarDocumentacion.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblGenerarDocumentacion.Attributes.Add("onclick", "generaDocumento();")

        lblGenerarCargoCuenta.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblGenerarCargoCuenta.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblGenerarCargoCuenta.Attributes.Add("onclick", "generaCargoCuenta();")

        lblGenerarCartaBaja.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblGenerarCartaBaja.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblGenerarCartaBaja.Attributes.Add("onclick", "generaCartasBaja(1);")

        lblGenerarCartaBaja2.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblGenerarCartaBaja2.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblGenerarCartaBaja2.Attributes.Add("onclick", "generaCartasBaja(2);")

        lblGenerarCartaBaja3.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblGenerarCartaBaja3.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblGenerarCartaBaja3.Attributes.Add("onclick", "generaCartasBaja(3);")

        lbleliminarIPC.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lbleliminarIPC.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lbleliminarIPC.Attributes.Add("onclick", "DelIPCContrato();")

        lbleliminarIPC2.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lbleliminarIPC2.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lbleliminarIPC2.Attributes.Add("onclick", "DelIPCFijoContrato();")

        lblTerminadoToVigente.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblTerminadoToVigente.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblTerminadoToVigente.Attributes.Add("onclick", "ToVigente();")

        lblbajamultiple.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
        lblbajamultiple.Attributes.Add("onmouseout", "this.style.color='white'; this.style.fontWeight='';")
        lblbajamultiple.Attributes.Add("onclick", "BajaMultipleAAEE();")
    End Sub

    Private Sub ReiniciarDropDownListEstadoContrato()
        Dim valor As New ListItem

        Select Case ddlCtrEstadoContrato.SelectedValue
            Case "C"
                valor = ddlCtrEstadoContrato.Items.FindByValue("P")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("V")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("T")
                ddlCtrEstadoContrato.Items.Remove(valor)
            Case "P"
                valor = ddlCtrEstadoContrato.Items.FindByValue("C")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("T")
                ddlCtrEstadoContrato.Items.Remove(valor)
            Case "V"
                valor = ddlCtrEstadoContrato.Items.FindByValue("C")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("P")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("A")
                ddlCtrEstadoContrato.Items.Remove(valor)
                If String.Compare(cacheContratacion.hfEsPerfilCentral.Value, "S", StringComparison.InvariantCultureIgnoreCase) <> 0 Then
                    valor = ddlCtrEstadoContrato.Items.FindByValue("T")
                    ddlCtrEstadoContrato.Items.Remove(valor)
                End If
            Case "T"
                valor = ddlCtrEstadoContrato.Items.FindByValue("C")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("P")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("A")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("V")
                ddlCtrEstadoContrato.Items.Remove(valor)
            Case "A"
                valor = ddlCtrEstadoContrato.Items.FindByValue("C")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("P")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("T")
                ddlCtrEstadoContrato.Items.Remove(valor)
                valor = ddlCtrEstadoContrato.Items.FindByValue("V")
                ddlCtrEstadoContrato.Items.Remove(valor)
        End Select
    End Sub

    Private Sub ProxyGridViews()
        Dim constWebService As String = "wsContratacion"

        gvAnaliticasPerfiles.wsProxy = constWebService
        gvAnaliticasCompuesta.wsProxy = constWebService
        gvAnaliticasSimple.wsProxy = constWebService
        gvProducto.wsProxy = constWebService
        gvProductoAutonomo.wsProxy = constWebService
        gvProductoBolsaHoras.wsProxy = constWebService
        gvPruebasExternasContrato.wsProxy = constWebService
        gvCentrosTrabajo.wsProxy = constWebService
        gvContactos.wsProxy = constWebService
        gvAnexos.wsProxy = constWebService
    End Sub

    Private Sub AñadirParametrosAOtrasActividades()
        Dim ccdCursosOtrasActividades As RfnCodDescripcionBound2 = CType(CType(Me.gvCursosFormacion.Configs(0), ConfigGE).Columnas(1), RfnCodDescripcionBound2)
        ccdCursosOtrasActividades.Parametros.Add("idContrato", txtCtrIdContrato.Text)
        ccdCursosOtrasActividades.Parametros.Add("esDirectorProvincial", cacheContratacion.hfEsPerfilDirProvincial.Value)
        ccdCursosOtrasActividades.Parametros.Add("esDirectorOficina", cacheContratacion.hfEsPerfilDirOficina.Value)
        ccdCursosOtrasActividades.Parametros.Add("esDirectorTerritorial", cacheContratacion.hfEsPerfilDirTerritorial.Value)
        ccdCursosOtrasActividades.Parametros.Add("esCentral", cacheContratacion.hfEsPerfilCentral.Value)
    End Sub

    Public Sub PuedeQuitarIPC(codContrato As Long)
        Dim val As Integer = Ipc1(codContrato)

        If val > 0 Then

            lbleliminarIPC.BackColor = Color.LightGray
            lbleliminarIPC2.BackColor = Color.LightGray
            lbleliminarIPC.ForeColor = Color.Black
            lbleliminarIPC2.ForeColor = Color.Black

            lbleliminarIPC2.Attributes.Clear()
            lbleliminarIPC.Attributes.Clear()

            lbleliminarIPC2.ToolTip = TEXTO_ELIMINA_IPC
            lbleliminarIPC.ToolTip = TEXTO_ELIMINA_IPC
            btneliminarIPC.ToolTip = TEXTO_ELIMINA_IPC
            btneliminarIPCpartefija.ToolTip = TEXTO_ELIMINA_IPC

        End If


    End Sub

    Private Function CargaControlesGenerales() As String

        Dim activarBtnEliminarIPC = ConstanteDatos.DameCte("A_ACTIVAR_BTN_IPC", TEXTO_SPA, tc)
        ddlEstadoPresupuesto.DataSource = Session.Item("EstadosPresupuesto")
        ddlEstadoPresupuesto.DataTextField = "DES_ESTADO"
        ddlEstadoPresupuesto.DataValueField = "COD_ESTADO"
        ddlEstadoPresupuesto.DataBind()

        ddlidioma.DataSource = Session.Item("Idiomas")
        ddlidioma.DataTextField = "NOMBRE"
        ddlidioma.DataValueField = "ID_IDIOMA"
        ddlidioma.DataBind()

        ddlEstadoPresupuestoOculto.DataSource = Session.Item("EstadosPresupuesto")
        ddlEstadoPresupuestoOculto.DataTextField = "DES_ESTADO"
        ddlEstadoPresupuestoOculto.DataValueField = "COD_ESTADO"
        ddlEstadoPresupuestoOculto.DataBind()

        ddlCtrEstadoContrato.DataSource = Session.Item("EstadosContrato")
        ddlCtrEstadoContrato.DataTextField = "DES_ESTADO"
        ddlCtrEstadoContrato.DataValueField = "COD_ESTADO"
        ddlCtrEstadoContrato.DataBind()

        ddlCtrEstadoContratoOculto.DataSource = Session.Item("EstadosContrato")
        ddlCtrEstadoContratoOculto.DataTextField = "DES_ESTADO"
        ddlCtrEstadoContratoOculto.DataValueField = "COD_ESTADO"
        ddlCtrEstadoContratoOculto.DataBind()

        ddlCtrEstadoContratoFirma.DataSource = Session.Item("EstadosContrato")
        ddlCtrEstadoContratoFirma.DataTextField = "DES_ESTADO"
        ddlCtrEstadoContratoFirma.DataValueField = "COD_ESTADO"
        ddlCtrEstadoContratoFirma.DataBind()

        ddllineaproducto.DataSource = Session.Item("LineasProducto")
        ddllineaproducto.DataTextField = "DES_LINEA_PROducto"
        ddllineaproducto.DataValueField = "ID_LINEA_PRODUCTO"
        ddllineaproducto.DataBind()

        Dim estadoContrato As String = ddlCtrEstadoContrato.SelectedValue
        estadoContrato = hfEstadoActualContrato.Value

        If estadoContrato = "" Then
            estadoContrato = ddlCtrEstadoContrato.DataTextField
            estadoContrato = ddlCtrEstadoContrato.SelectedValue
        End If

        If (estadoContrato <> Parametro("indEstadoContrato") AndAlso Parametro("indEstadoContrato") <> "") Then
            estadoContrato = Parametro("indEstadoContrato")
        End If

        ddlobser.DataSource = dameTiposObserv(Usuario.Login)
        ddlobser.DataTextField = "DES_OBSERVACIONES"
        ddlobser.DataValueField = "ID_TIPO_OBSERVACIONES"
        ddlobser.DataBind()

        ddlCtrCausaBaja.DataSource = dameCausasBaja()
        ddlCtrCausaBaja.DataTextField = "DES_CAUSA_BAJA"
        ddlCtrCausaBaja.DataValueField = "ID_CAUSA_BAJA"
        ddlCtrCausaBaja.DataBind()

        ddlCtrCausaBaja2.DataSource = dameCausasBaja()
        ddlCtrCausaBaja2.DataTextField = "DES_CAUSA_BAJA"
        ddlCtrCausaBaja2.DataValueField = "ID_CAUSA_BAJA"
        ddlCtrCausaBaja2.DataBind()

        ObtenerPersona()

        cmbProvinciaDS.DataSource = dameRegiones()
        cmbProvinciaDS.DataTextField = "DESCRIPCION"
        cmbProvinciaDS.DataValueField = "ID_REGION"
        cmbProvinciaDS.DataBind()

        FcmbProvincia.DataSource = dameRegiones()
        FcmbProvincia.DataTextField = "DESCRIPCION"
        FcmbProvincia.DataValueField = "ID_REGION"
        FcmbProvincia.DataBind()

        cmbProvincia.DataSource = dameRegiones()
        cmbProvincia.DataTextField = "DESCRIPCION"
        cmbProvincia.DataValueField = "ID_REGION"
        cmbProvincia.DataBind()

        cmbProvinciaEnvFactP.DataSource = dameRegiones()
        cmbProvinciaEnvFactP.DataTextField = "DESCRIPCION"
        cmbProvinciaEnvFactP.DataValueField = "ID_REGION"
        cmbProvinciaEnvFactP.DataBind()

        cmbProvinciaNotario1.DataSource = dameRegiones()
        cmbProvinciaNotario1.DataTextField = "DESCRIPCION"
        cmbProvinciaNotario1.DataValueField = "ID_REGION"
        cmbProvinciaNotario1.DataBind()

        cmbProvinciaNotario2.DataSource = dameRegiones()
        cmbProvinciaNotario2.DataTextField = "DESCRIPCION"
        cmbProvinciaNotario2.DataValueField = "ID_REGION"
        cmbProvinciaNotario2.DataBind()

        cmbProvinciaEnvFact.DataSource = dameRegiones()
        cmbProvinciaEnvFact.DataTextField = "DESCRIPCION"
        cmbProvinciaEnvFact.DataValueField = "ID_REGION"
        cmbProvinciaEnvFact.DataBind()

        cmbTipoViaDS.DataSource = DameTipoVias()
        cmbTipoViaDS.DataTextField = "DES_TIPO_VIA"
        cmbTipoViaDS.DataValueField = "COD_TIPO_VIA"
        cmbTipoViaDS.DataBind()

        cmbTipoViaEnvFactP.DataSource = DameTipoVias()
        cmbTipoViaEnvFactP.DataTextField = "DES_TIPO_VIA"
        cmbTipoViaEnvFactP.DataValueField = "COD_TIPO_VIA"
        cmbTipoViaEnvFactP.DataBind()

        cmbTipoVia.DataSource = DameTipoVias()
        cmbTipoVia.DataTextField = "DES_TIPO_VIA"
        cmbTipoVia.DataValueField = "COD_TIPO_VIA"
        cmbTipoVia.DataBind()

        cmbTipoViaEnvFact.DataSource = DameTipoVias()
        cmbTipoViaEnvFact.DataTextField = "DES_TIPO_VIA"
        cmbTipoViaEnvFact.DataValueField = "COD_TIPO_VIA"
        cmbTipoViaEnvFact.DataBind()

        Dim dtListadoContratos As New DataTable

        Using wsContratacion As New WsContratacion.WsContratacion
            dtListadoContratos = descomprimirDataset(wsContratacion.BuscaListaContratosPorIdCliente(hfidCliente.Value, Usuario.Login)).Tables(0)
        End Using

        cmbListaContratosCliente.DataSource = dtListadoContratos
        cmbListaContratosCliente.DataTextField = "COD_CONTRATO"
        cmbListaContratosCliente.DataValueField = "ID_CONTRATO"
        cmbListaContratosCliente.DataBind()

        cmbPlazoPago.Items.Clear()

        Dim pago0 As New ListItem
        Dim pago30 As New ListItem
        Dim pago60 As New ListItem
        Dim pago90 As New ListItem
        Dim pago120 As New ListItem
        Dim pago7 As New ListItem
        Dim pago15 As New ListItem
        Dim pago45 As New ListItem
        Dim pago75 As New ListItem
        Dim pago180 As New ListItem

        pago120.Value = "0"
        pago120.Text = "120"

        pago0.Value = "1"
        pago0.Text = "0"

        pago7.Value = "2"
        pago7.Text = "7"

        pago30.Value = "3"
        pago30.Text = "30"

        pago15.Value = "4"
        pago15.Text = "15"

        pago45.Value = "5"
        pago45.Text = "45"

        pago60.Value = "6"
        pago60.Text = "60"

        pago90.Value = "9"
        pago90.Text = "90"

        pago75.Value = "7"
        pago75.Text = "75"

        pago180.Value = "8"
        pago180.Text = "180"

        cmbPlazoPago.Items.Add(pago0)
        cmbPlazoPago.Items.Add(pago7)
        cmbPlazoPago.Items.Add(pago15)
        cmbPlazoPago.Items.Add(pago30)
        cmbPlazoPago.Items.Add(pago45)
        cmbPlazoPago.Items.Add(pago60)
        cmbPlazoPago.Items.Add(pago75)
        cmbPlazoPago.Items.Add(pago90)
        cmbPlazoPago.Items.Add(pago120)
        cmbPlazoPago.Items.Add(pago180)

        Dim activar_anex_analitica As String
        Dim activar_anex_renovacion As String

        Activar_Otras_VSI = ConstanteDatos.DameCte("A_PRUEBAS_VSI", TEXTO_SPA, tc)
        activar_anex_analitica = Constante.ObtenerValor("ACT_ANEX_ANALI", TEXTO_SPA).ToString(CultureInfo.InvariantCulture)
        activar_anex_renovacion = Constante.ObtenerValor("CONTRA_BAYES", TEXTO_SPA).ToString(CultureInfo.InvariantCulture)

        hfANEXANAL.Value = activar_anex_analitica
        hfANEXRENO.Value = activar_anex_renovacion

        If Activar_Otras_VSI = "S" Then
            crearAnexoAnaliticas.Style.Add("display", "none")
        Else
            If activar_anex_analitica = "S" AndAlso cacheContratacion.hfEsPerfilCentral.Value = "S" Then
                crearAnexoAnaliticas.Style.Add("display", "block")
            End If
        End If


        Dim perf_anex_renovacion As Boolean
        perf_anex_renovacion = PermisoContraBayes(Usuario.Login)

        If activar_anex_renovacion = "S" AndAlso hfidtarifabayes.Value = "S" AndAlso perf_anex_renovacion Then
            Dim dtAnex As DataTable

            dtAnex = UltimoAnexoContrato(txtCtrIdContrato.Text)
            hfCodUltimoAnexoContrato.Value = dtAnex.Rows(0)("COD_ANEXO").ToString
            hfFecUltimoAnexoContrato.Value = dtAnex.Rows(0)("FECHA_ALTA").ToString

            If hfCodUltimoAnexoContrato.Value <> "" Then
                hfRecosTramo.Value = ContratoTramosRMBaja(txtCtrIdContrato.Text, hfCodUltimoAnexoContrato.Value)
            End If
            crearAnexoRenovacion.Style.Add("display", "block")
        End If


        Dim permiso As String = ObtenerP()

        Dim VALGE As Integer
        VALGE = ValidaUsuarioRIPC(Usuario.Login.ToUpper(CultureInfoSpain))

        TipoPresupuesto = EsPreupuestoQS(txtCtrCodContrato.Text)

        If activarBtnEliminarIPC = "S" AndAlso TipoPresupuesto = 0 Then
            If VALGE >= 1 Then
                eliminarIPC.Style.Add("display", "block")
                lbleliminarIPC.Style.Add("display", "block")
                eliminarIPC2.Style.Add("display", "block")
                lbleliminarIPC2.Style.Add("display", "block")
                PuedeQuitarIPC(CLng(txtCtrCodContrato.Text))
            Else
                lbleliminarIPC2.Attributes.Clear()
                lbleliminarIPC.Attributes.Clear()
            End If
        End If


        Dim ActivarRegAnexos As Integer
        ActivarRegAnexos = DamePerfilesUsuarioRegAnexo(Usuario.Login)


        If ActivarRegAnexos = 0 Then
            DesActAnexo.Value = 1
        Else
            DesActAnexo.Value = 0
        End If

        If permiso = "S" AndAlso estadoContrato = "V" AndAlso cacheContratacion.hfEsPerfilCentral.Value = "S" Then
            DBajaMultiple.Style.Add("display", "block")
            grupoCtrBaja2.Style.Add("display", "block")

        End If

        ConfigurarGridOtrasActividades(estadoContrato)

        Me.AddLoadScript("filtrarEstados();")
    End Function

    Private Sub ConfigurarGridOtrasActividades(estadoContrato As String)
        Dim contratoDatos As DataRow = Comun.Datos.ContratoDatos.CargaContrato(txtCtrIdContrato.Text, Nothing, tc)
        Dim tipoContrato As String = contratoDatos("IND_TIPO_CONTRATO").ToString.Trim

        Dim estadoActualContrato As String = ""
        If hfEstadoActualContrato.Value <> "" Then
            estadoActualContrato = ddlCtrEstadoContrato.Items(hfEstadoActualContrato.Value).Value
        End If

        If estadoContrato <> "V" AndAlso estadoActualContrato <> "V" Then
            OcultarGridOtrasActividades()
        End If

        If tipoContrato <> "T" AndAlso tipoContrato <> "P" Then
            OcultarGridOtrasActividades()
        End If

        If estadoContrato <> estadoActualContrato AndAlso estadoActualContrato = "V" AndAlso
            (tipoContrato = "T" OrElse tipoContrato = "P") Then
            MostrarGridOtrasActividades()
        End If

        If cacheContratacion.hfEsPerfilDirTerritorial.Value <> "S" AndAlso cacheContratacion.hfEsPerfilCentral.Value <> "S" AndAlso cacheContratacion.hfEsPerfilDirOficina.Value <> "S" AndAlso cacheContratacion.hfEsPerfilDirProvincial.Value <> "S" Then
            DeshabilitarGridOtrasActividades()
        End If

        If grupoOtrasActividades.Display <> "none" Then
            hiddenNombreCompleto.Value = Me.NombreCompleto(Usuario.Login)
        End If
    End Sub

    Private Sub DeshabilitarGridOtrasActividades()
        grupoOtrasActividades.Enabled = "False"
        Dim config_gvCursosFormacion As ConfigGE = DirectCast(Me.gvCursosFormacion.Configs(0), ConfigGE)
        config_gvCursosFormacion.EnableAddRow = False
        config_gvCursosFormacion.EnableDeleteRow = False
        config_gvCursosFormacion.EnableEditRow = False

    End Sub

    Private Sub MostrarGridOtrasActividades()
        grupoOtrasActividades.Display = "table"
        gvCursosFormacion.AutoLoad = True

    End Sub

    Private Sub OcultarGridOtrasActividades()
        grupoOtrasActividades.Display = "none"
        gvCursosFormacion.AutoLoad = False

    End Sub

    Private Sub ObtenerPersona()

        Dim wsContratacion As New WsContratacion.WsContratacion

        Dim dtPersona As New DataTable

        dtPersona = descomprimirDataset(wsContratacion.ObtenerPersonas(Usuario.Login)).Tables(0)

        If dtPersona IsNot Nothing Then

            Dim iCodPersona As Integer = 0

            Integer.TryParse(dtPersona.Rows(0)("COD_PERSONA").ToString.Trim, iCodPersona)

            If iCodPersona > 0 Then

                hfCodEMPPRL.Value = dtPersona.Rows(0)("COD_EMPPRL")
                hfCodPersona.Value = dtPersona.Rows(0)("COD_PERSONA")
                hfCodCentGest.Value = dtPersona.Rows(0)("COD_CENTRO_GEST")

            End If

        End If

    End Sub

    Private Sub ObtenerProductoEspecialMedicina()

        hfProductoEspecialMedicina.Value = Constante.ObtenerValor("SPA_PROD_RECOS_EXP", TEXTO_SPA).ToString(CultureInfoSpain)

    End Sub

    Private Function ObtenerP() As String

        Return Constante.ObtenerValor("ACT_DESA_PTE", TEXTO_SPA).ToString(CultureInfoSpain)

    End Function
    Public Function ValidarDatosFace() As Integer

        Dim retorno As Integer = Nothing

        Dim contadorFace As Integer = Nothing
        Dim espacio As Integer = Nothing
        Dim iCadena1 As Integer = Nothing
        Dim iCadena2 As Integer = Nothing
        Dim sCadena1 As String = Nothing
        Dim sCadena2 As String = Nothing
        Dim longitud As Integer = Nothing
        Dim longitud2 As Integer = Nothing
        Dim iAux As Integer = Nothing
        Dim caracter1 As String = Nothing
        Dim caracter2 As String = Nothing
        Dim letras As String = Nothing
        Dim esPublica As Boolean = False

        letras = ccdRazonSocial1.Codigo.ToString(CultureInfoSpain).Substring(0, 1)
        If letras <> "P" AndAlso letras <> "Q" AndAlso letras <> "S" Then
            'And Letras <> "R"
            contadorFace = 5
            hfface.Value = 0
            esPublica = False
            Return 0
        Else
            esPublica = True
            If (cmbProvinciaDS.SelectedValue = 1 OrElse cmbProvinciaDS.SelectedValue = 20 OrElse cmbProvinciaDS.SelectedValue = 48) Then
                esPublica = True
                contadorFace = 5
                hfface.Value = 0
                Return 0
            End If


        End If

        If Me.txtUnidadTramitadora.Text <> "" AndAlso txtUnidadTramitadora.Text.Length > 9 Then

            caracter1 = txtUnidadTramitadora.Text.Substring(0, 1).ToUpper(CultureInfoSpain)

            If caracter1 = "G" OrElse caracter1 = "E" OrElse caracter1 = "A" OrElse caracter1 = "L" OrElse caracter1 = "U" OrElse caracter1 = "I" OrElse caracter1 = "J" Then

                caracter2 = txtUnidadTramitadora.Text.Substring(1, 1).ToUpper(CultureInfoSpain)
                If caracter1 = "G" AndAlso caracter2 <> "E" Then

                    retorno = 1
                End If
            Else
                retorno = 1
            End If

            longitud = txtUnidadTramitadora.Text.Length
            contadorFace = contadorFace + 1

            espacio = txtUnidadTramitadora.Text.IndexOf(" ")

            Select Case espacio
                Case -1
                    retorno = 1
                Case > 9
                    retorno = 1
                Case < 9
                    retorno = 1
                Case 9
                    sCadena1 = txtUnidadTramitadora.Text.Substring(0, espacio)
                    sCadena2 = txtUnidadTramitadora.Text.Substring(espacio + 1, (longitud - espacio) - 1)

                    If sCadena2.Length = 1 Then
                        iAux = sCadena2.IndexOf("_")
                        If iAux = -1 Then
                            retorno = 1
                        End If
                    End If

            End Select

        Else
            If esPublica = True Then
                retorno = 1
            End If

        End If

        espacio = Nothing
        iCadena1 = Nothing
        iCadena2 = Nothing
        sCadena1 = Nothing
        sCadena2 = Nothing
        longitud = Nothing
        longitud2 = Nothing
        iAux = Nothing
        caracter1 = Nothing
        caracter2 = Nothing

        If Me.txtOrganoGestor.Text <> "" AndAlso txtOrganoGestor.Text.Length > 9 Then

            caracter1 = txtOrganoGestor.Text.Substring(0, 1).ToUpper(CultureInfoSpain)
            If caracter1 = "G" OrElse caracter1 = "E" OrElse caracter1 = "A" OrElse caracter1 = "L" OrElse caracter1 = "U" OrElse caracter1 = "I" OrElse caracter1 = "J" Then

                caracter2 = txtOrganoGestor.Text.Substring(1, 1).ToUpper(CultureInfoSpain)
                If caracter1 = "G" AndAlso caracter2 <> "E" Then

                    retorno = 1
                End If
            Else
                retorno = 1
            End If

            longitud = txtOrganoGestor.Text.Length
            contadorFace = contadorFace + 1
            espacio = txtOrganoGestor.Text.IndexOf(" ")

            Select Case espacio
                Case -1
                    retorno = 1
                Case > 9
                    retorno = 1
                Case < 9
                    retorno = 1
                Case 9
                    sCadena1 = txtOrganoGestor.Text.Substring(0, espacio)
                    sCadena2 = txtOrganoGestor.Text.Substring(espacio + 1, (longitud - espacio) - 1)

                    If sCadena2.Length = 1 Then
                        iAux = sCadena2.IndexOf("_")
                        If iAux = -1 Then
                            retorno = 1
                        End If
                    End If


            End Select

        Else
            If esPublica = True Then
                retorno = 1
            End If
        End If

        espacio = Nothing
        iCadena1 = Nothing
        iCadena2 = Nothing
        sCadena1 = Nothing
        sCadena2 = Nothing
        longitud = Nothing
        longitud2 = Nothing
        iAux = Nothing
        caracter1 = Nothing
        caracter2 = Nothing

        If Me.txtOficinaContable.Text <> "" AndAlso txtOficinaContable.Text.Length > 9 Then
            caracter1 = txtOficinaContable.Text.Substring(0, 1).ToUpper(CultureInfoSpain)

            If caracter1 = "G" OrElse caracter1 = "E" OrElse caracter1 = "A" OrElse caracter1 = "L" OrElse caracter1 = "U" OrElse caracter1 = "I" OrElse caracter1 = "J" Then

                caracter2 = txtOficinaContable.Text.Substring(1, 1).ToUpper(CultureInfoSpain)
                If caracter1 = "G" AndAlso caracter2 <> "E" Then

                    retorno = 1
                End If
            Else
                retorno = 1
            End If

            longitud = txtOficinaContable.Text.Length
            contadorFace = contadorFace + 1
            espacio = txtOficinaContable.Text.IndexOf(" ")

            Select Case espacio
                Case -1
                    retorno = 1
                Case > 9
                    retorno = 1
                Case < 9
                    retorno = 1
                Case 9
                    sCadena1 = txtOficinaContable.Text.Substring(0, espacio)
                    sCadena2 = txtOficinaContable.Text.Substring(espacio + 1, (longitud - espacio) - 1)

                    If sCadena2.Length = 1 Then
                        iAux = sCadena2.IndexOf("_")
                        If iAux = -1 Then
                            retorno = 1
                        End If
                    End If

            End Select

        Else
            If esPublica = True Then
                retorno = 1
            End If

        End If

        If contadorFace < 3 Then
            If retorno <> 1 Then
                retorno = 2
            End If

            If contadorFace = 0 AndAlso esPublica Then
                retorno = 2
            End If
        End If

        Return retorno

    End Function

    Private Function ValidacionesDatosFace() As Boolean
        If chkDatosFACE.Checked Then

            Dim faceValido As Integer = ValidarDatosFace()

            Select Case faceValido
                Case 0
                    hfface.Value = 0
                Case 1
                    hfface.Value = 0
                    AddLoadScript("ErrorFace();")
                    Return False
                Case 2
                    hfface.Value = 1
                    If EstadoContratoValidacionFace() Then
                        AddLoadScript("ErrorFace2();")
                        Return False
                    End If
            End Select

        Else

            Dim letras As String = ccdRazonSocial1.Codigo.ToString(CultureInfoSpain).Substring(0, 1)
            If letras = "P" OrElse letras = "Q" OrElse letras = "S" Then
                hfface.Value = 1
                If EstadoContratoValidacionFace() Then
                    AddLoadScript("ErrorFace2();")
                    Return False
                End If
            Else
                hfface.Value = 0
            End If

        End If

        Return True
    End Function

    Private Function EstadoContratoValidacionFace() As Boolean
        Return ddlCtrEstadoContrato.SelectedValue = "V" AndAlso ddlCtrEstadoContratoOculto.SelectedValue <> "V" AndAlso cacheContratacion.hfEsPerfilCentral.Value <> "S"
    End Function

    Private Function ObtenerTarifaControl() As String

        If ccdTarifaModalidad.InfoExtra.Count > 0 Then
            If ccdTarifaModalidad.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                Return ObtenerValorDeCcd(ccdTarifaModalidad, "ID_TIP_TARIF")
            End If
        ElseIf ccdTarifaProductos.InfoExtra.Count > 0 Then
            If ccdTarifaProductos.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                Return ObtenerValorDeCcd(ccdTarifaProductos, "ID_TIP_TARIF")
            End If
        ElseIf ccdTarifaBolsaHoras.InfoExtra.Count > 0 Then
            If ccdTarifaBolsaHoras.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                Return ObtenerValorDeCcd(ccdTarifaBolsaHoras, "ID_TIP_TARIF")
            End If
        ElseIf ccdTarifaAutonomos.InfoExtra.Count > 0 Then
            If ccdTarifaAutonomos.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                Return ObtenerValorDeCcd(ccdTarifaAutonomos, "ID_TIP_TARIF")
            End If
        End If

        Return ""

    End Function

    Private Function ObtenerValorDeCcd(ccd As RFNCodDescripcion, clave As String) As String
        Try
            Return ccd.InfoExtra(clave).ToString(CultureInfoSpain).Trim
        Catch ex As Exception
            Traces.TrackException(ex, tc, pageName, "Error al intentar obtener valor correspondiente a la clave --> " & clave)
            Return ""
        End Try
    End Function

    Private Sub RellenarDatosContrato(ByRef drContrato As DataRow)

        Try
            drContrato("ID_CLIENTE") = hfidCliente.Value

            drContrato("ID_CONTRATO") = txtCtrIdContrato.Text
            drContrato("COD_CONTRATO") = txtCtrCodContrato.Text

            drContrato("DES_OBS_TEC") = txtCtrObservacionesTec.Text
            drContrato("DES_OBS_MED") = txtCtrObservacionesMed.Text

            If ddlCtrEstadoContrato.SelectedValue <> ddlCtrEstadoContratoOculto.SelectedValue Then
                drContrato("IND_ESTADO") = ddlCtrEstadoContrato.SelectedValue
            Else
                drContrato("IND_ESTADO") = ""
            End If

            drContrato("IND_AAPP") = MetodosAux.CheckAString(chkAAPP)

            drContrato("DES_REF_FACTURA") = txtRefFact.Text.Trim

            drContrato("DES_INCIDENCIAS") = txtCtrObservaciones.Text

            drContrato("IND_FORM_BONIF") = "N"

            drContrato("FEC_FIRMA") = calCtrFecFirma1.Fecha
            drContrato("COD_CENTRO_GEST") = ccdCentroGestion.Codigo

            drContrato("DIRECTIVO_1") = ccdCtrDirectivo1.Codigo
            drContrato("DIRECTIVO_2") = ccdCtrDirectivo2.Codigo

            drContrato("PODER_1") = txtCtrPoderDirectivo1.Text
            drContrato("PODER_2") = txtCtrPoderDirectivo2.Text

            drContrato("COD_COLABORADOR") = ccdCtrColaborador.Codigo
            drContrato("POR_COMISION") = txtCtrPorcentajeColab.Text
            drContrato("FEC_VINCULACION") = calCtrFecColabDesde.Fecha

            drContrato("COD_PERSONA_COMERC1") = ccdCtrRespCaptacion.Codigo
            drContrato("COD_PERSONA_COMERC2") = ccdCtrRespRenovacion.Codigo

            drContrato("CONTRATO_ANTIGUO") = txtCtrContratoAntiguo.Text
            drContrato("CONTRATO_NUEVO") = txtCtrContratoNuevo.Text

            If ccdActividad.InfoExtra.Count = 1 Then
                drContrato("ID_ACTIVIDAD") = ObtenerValorDeCcd(ccdActividad, "ID_ACTIVIDAD")
            End If

            drContrato("COD_ACTIVIDAD") = ccdActividad.Codigo

            Select Case ddlCtrEstadoContrato.SelectedValue
                Case "A"
                    drContrato("FEC_BAJA") = calCtrFecBaja.Fecha
                    drContrato("FEC_TERMINADO") = Date.MinValue
                Case "T"
                    drContrato("FEC_TERMINADO") = calCtrFecBaja.Fecha
                    drContrato("FEC_BAJA") = Date.MinValue
                Case Else
                    drContrato("FEC_TERMINADO") = Date.MinValue
                    drContrato("FEC_BAJA") = Date.MinValue
            End Select

            If calCtrFecBaja.Fecha <> Date.MinValue Then

                drContrato("ID_CAUSA_BAJA") = ddlCtrCausaBaja.SelectedValue
                drContrato("DES_OBSERV_BAJA") = txtCtrObservBaja.Text

                If chkCtrBajaFutura.Checked Then
                    drContrato("IND_BAJA_FUTURA") = "S"
                    drContrato("FEC_BAJA_FUTURA") = calCtrFecBaja.Fecha
                    drContrato("FEC_BAJA") = Date.MinValue
                Else
                    drContrato("IND_BAJA_FUTURA") = "N"
                    drContrato("FEC_BAJA_FUTURA") = Date.MinValue
                End If

            Else
                drContrato("FEC_BAJA_FUTURA") = Date.MinValue
                drContrato("FEC_TERMINADO") = Date.MinValue
                drContrato("FEC_BAJA_ESP") = Date.MinValue
                drContrato("IND_BAJA_FUTURA") = "N"
                drContrato("ID_CAUSA_BAJA") = "0"
                drContrato("DES_OBSERV_BAJA") = ""
            End If

            If calFecUltReno.Fecha <> Date.MinValue Then
                drContrato("FEC_ULT_RENOV") = calFecUltReno.Fecha
            Else
                drContrato("FEC_ULT_RENOV") = Date.MinValue
            End If

            If calFecFin.Fecha <> Date.MinValue Then
                drContrato("FEC_BAJA_ESP") = calFecFin.Fecha
            Else
                drContrato("FEC_BAJA_ESP") = Date.MinValue
            End If

            If chkIndIPC.Checked Then
                drContrato("IND_IPC") = "S"
                drContrato("FEC_IPC") = calIPCDesde.Fecha
            Else
                drContrato("IND_IPC") = "N"
                drContrato("FEC_IPC") = Date.MinValue
            End If

            drContrato("IND_RECORDATORIO_IPC") = MetodosAux.CheckAString(chkRecordatorioIPC)

            drContrato("IND_CARTERA") = MetodosAux.CheckAString(chkCarteraNegociada)
            If chkCarteraNegociada.Checked Then
                drContrato("FEC_INICIO_FACT") = calFecIniFact.Fecha
            Else
                drContrato("FEC_INICIO_FACT") = Date.MinValue
            End If

            drContrato("IND_FACT_LIBRE") = MetodosAux.CheckAString(chkFactLibre)
            drContrato("IND_RENOVABLE") = MetodosAux.CheckAString(RFNchkRenovable)
            drContrato("IND_FACT_LIBRE_F") = MetodosAux.CheckAString(chkFactLibreF)
            drContrato("IND_FACT_LIBRE_V") = MetodosAux.CheckAString(chkFactLibreV)
            drContrato("IND_FL_REC") = MetodosAux.CheckAString(chkFLrec)
            drContrato("IND_FL_ANA") = MetodosAux.CheckAString(chkFLana)
            drContrato("IND_FL_VSI") = MetodosAux.CheckAString(chkFLvsi)
            drContrato("IND_F_COMI") = MetodosAux.CheckAString(chkFcomi)
            drContrato("IND_F_UNI_VSI") = MetodosAux.CheckAString(chkFactUniVsi)
            drContrato("IND_CANCELACION_UM") = MetodosAux.CheckAString(chkCancenlacionUM)
            drContrato("IND_FACT_ANALITICA") = MetodosAux.CheckAString(chkFactAnal)
            drContrato("IND_CANCELACION_UM") = MetodosAux.CheckAString(chkCancenlacionUM)


            If rfncalInicioSuspendido2.Fecha <> Date.MinValue Then
                drContrato("FEC_INI_SUSP") = rfncalInicioSuspendido2.Fecha
            Else
                drContrato("FEC_INI_SUSP") = Nothing
            End If

            If rfncalfinSuspendido.Fecha <> Date.MinValue Then
                drContrato("FEC_FIN_SUSP") = rfncalfinSuspendido.Fecha
            Else
                drContrato("FEC_FIN_SUSP") = Nothing
            End If

            drContrato("IND_SERES") = rdSeres.SelectedValue
            drContrato("IND_FIRMA") = rdfirmaxml.SelectedValue

            drContrato("IND_RET_PDF_F") = MetodosAux.CheckAString(chkRetPdfF)
            drContrato("IND_RET_PDF_V") = MetodosAux.CheckAString(chkRetPdfV)

            If txtNumPedidoF.Text = Nothing Then
                drContrato("NUM_PEDIDO_F") = Nothing
            Else
                drContrato("NUM_PEDIDO_F") = txtNumPedidoF.Text
            End If

            If txtNumPedidoV.Text = Nothing Then
                drContrato("NUM_PEDIDO_V") = Nothing
            Else

                drContrato("NUM_PEDIDO_V") = txtNumPedidoV.Text
            End If

            drContrato("IND_FACT_REG") = "N"

            drContrato("IND_FACT_ELECTRONICA") = MetodosAux.CheckAString(chkFactElectronica)
            drContrato("IND_CAPT_AAEE") = MetodosAux.CheckAString(chkCaptacionAAEE)
            drContrato("IND_FACT_PERIODO_VENC") = MetodosAux.CheckAString(chkFactPeriodoVenc)

            If chkFactPorCentro.Checked Then

                drContrato("IND_ENV_AL_CENTRO") = MetodosAux.CheckAString(chkEnvCentro)

                drContrato("IND_FACT_MOD_CENT") = MetodosAux.CheckAString(chkFactModCent)
                If chkFactModCent.Checked Then
                    drContrato("FEC_FACT_MOD_CENT") = calFecFactModCentDesde.Fecha
                Else
                    drContrato("FEC_FACT_MOD_CENT") = Date.MinValue
                End If

                drContrato("IND_FACT_ANA_CENT") = MetodosAux.CheckAString(chkFactAnalCent)
                If chkFactAnalCent.Checked Then
                    drContrato("FEC_FACT_ANA_CENT") = calFecFactAnalCentDesde.Fecha
                Else
                    drContrato("FEC_FACT_ANA_CENT") = Date.MinValue
                End If

                drContrato("IND_FACT_RECO_CENT") = MetodosAux.CheckAString(chkFactRecMedCent)
                If chkFactRecMedCent.Checked Then
                    drContrato("FEC_FACT_RECO_CENT") = calFecFactRecMedCentDesde.Fecha
                Else
                    drContrato("FEC_FACT_RECO_CENT") = Date.MinValue
                End If

            Else
                drContrato("IND_ENV_AL_CENTRO") = "N"
                drContrato("IND_FACT_MOD_CENT") = "N"
                drContrato("IND_FACT_ANA_CENT") = "N"
                drContrato("IND_FACT_RECO_CENT") = "N"
                drContrato("FEC_FACT_MOD_CENT") = Date.MinValue
                drContrato("FEC_FACT_ANA_CENT") = Date.MinValue
                drContrato("FEC_FACT_RECO_CENT") = Date.MinValue
            End If

            drContrato("IND_MOD_FACTURA") = rblPeriPago.SelectedValue
            drContrato("IND_TIPO_FACTURA") = rblTipoPago.SelectedValue
            drContrato("IND_PLAZO_VENC") = cmbPlazoPago.SelectedValue

            If String.Compare(rblTipoPago.SelectedValue, "D", StringComparison.InvariantCultureIgnoreCase) = 0 Then

                drContrato("COD_CTA_BANCARIA") = txtIban.Text
                drContrato("ID_TITULAR") = txtIdentificador.Text.Trim.ToUpper(CultureInfoSpain)

                If String.Compare(rblColInd.SelectedValue, "COLECTIVO", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                    If txtNombreCompleto.Text.Trim.ToUpper(CultureInfoSpain).Length < 40 Then
                        drContrato("NOM_TITULAR") = txtNombreCompleto.Text.Trim.ToUpper(CultureInfoSpain)
                    Else
                        drContrato("NOM_TITULAR") = txtNombreCompleto.Text.Trim.ToUpper(CultureInfoSpain).Substring(0, 39)
                    End If
                Else
                    Dim nombre As String = ""
                    Dim apellido1 As String = ""
                    Dim apellido2 As String = ""

                    If txtNombre.Text.Trim.ToUpper(CultureInfoSpain).Length < 15 Then
                        nombre = txtNombre.Text.Trim.ToUpper(CultureInfoSpain)
                    Else
                        nombre = txtNombre.Text.Trim.ToUpper(CultureInfoSpain).Substring(0, 14)
                    End If

                    If txtApellido1.Text.Trim.ToUpper(CultureInfoSpain).Length < 15 Then
                        apellido1 = txtApellido1.Text.Trim.ToUpper(CultureInfoSpain)
                    Else
                        apellido1 = txtApellido1.Text.Trim.ToUpper(CultureInfoSpain).Substring(0, 14)
                    End If

                    If txtApellido2.Text.Trim.ToUpper(CultureInfoSpain).Length < 10 Then
                        apellido2 = txtApellido2.Text.Trim.ToUpper(CultureInfoSpain)
                    Else
                        apellido2 = txtApellido2.Text.Trim.ToUpper(CultureInfoSpain).Substring(0, 9)
                    End If

                    drContrato("NOM_TITULAR") = (String.Concat(apellido1, "|", apellido2, "|", nombre)).ToString(CultureInfoSpain)
                End If

            Else
                drContrato("NOM_TITULAR") = ""
                drContrato("ID_TITULAR") = ""
                drContrato("COD_CTA_BANCARIA") = ""
            End If

            drContrato("DES_PERSONA_ATENC") = txtAtencionEnvFact.Text.Trim
            drContrato("DES_EMAIL_ENVIO") = txtEmailEnvFact.Text.Trim

            Dim direccion As String = ""

            direccion = DomicilioDatos.GeneraDireccion(cmbTipoViaEnvFact.SelectedValue, txtCalleEnvFact.Text.Trim, txtNumEnvFact.Text.Trim, txtPortalEnvFact.Text.Trim, txtEscaleraEnvFact.Text.Trim, txtPisoEnvFact.Text.Trim, txtPuertaEnvFact.Text.Trim)

            drContrato("ID_PROVINCIA_DOMIC") = cmbProvinciaEnvFact.SelectedValue
            drContrato("ID_POBLACION_DOMIC") = ccdPoblacionEnvFact.Codigo
            drContrato("CP_DOMIC") = cmbCPEnvFact.SelectedValue
            drContrato("DIRECCION_DOMIC") = direccion
            drContrato("TELEFONO_DOMIC") = txtTelefonoEnvFact.Text.Trim
            drContrato("FAX_DOMIC") = txtNumFaxEnvFact.Text.Trim

            drContrato("ID_DOMI_SOCIAL") = hfIdDomiSocial.Value
            drContrato("ID_DOMI_ENVIO") = hfIdDomiEnvio.Value

            drContrato("DES_EMAIL_SOCIAL") = txtEmailDS.Text.Trim

            If Not String.IsNullOrEmpty(ccdPrimerRepresentante.Codigo) Then

                Dim nombreNotario1 As String = ""

                nombreNotario1 = String.Concat(txtCtrApellido1Notario1.Text.Trim.ToUpper(CultureInfoSpain), "|", txtCtrApellido2Notario1.Text.Trim.ToUpper(CultureInfoSpain), "|", txtCtrNombreNotario1.Text.Trim.ToUpper(CultureInfoSpain)).ToString(CultureInfoSpain)

                If chkTextoNotario1.Checked Then
                    drContrato("COD_CONTACTO_REPRE_1") = ObtenerValorDeCcd(ccdPrimerRepresentante, "COD_CONTACTO")
                    drContrato("IDENTIFICADOR_REPRE_1") = txtCtrIdentificadorRepresentante1.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("CARGO_REPRE_1") = txtCtrCargoRepresentante1.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("ID_PROVINCIA_REPRE_1") = ""
                    drContrato("ID_POBLACION_REPRE_1") = ""
                    drContrato("PROTOCOLO_REPRE_1") = ""
                    drContrato("FEC_NOTARIO_REPRE_1") = Date.MinValue
                    drContrato("DES_NOTARIO_REPRE_1") = txtTextoNotario1.Text
                    drContrato("NOM_NOTARIO_REPRE_1") = ""
                Else
                    drContrato("COD_CONTACTO_REPRE_1") = ObtenerValorDeCcd(ccdPrimerRepresentante, "COD_CONTACTO")
                    drContrato("IDENTIFICADOR_REPRE_1") = txtCtrIdentificadorRepresentante1.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("CARGO_REPRE_1") = txtCtrCargoRepresentante1.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("ID_PROVINCIA_REPRE_1") = cmbProvinciaNotario1.SelectedValue
                    drContrato("ID_POBLACION_REPRE_1") = ccdCtrPoblacionNotario1.Codigo
                    drContrato("PROTOCOLO_REPRE_1") = txtCtrProtocoloNotario1.Text.Trim
                    drContrato("FEC_NOTARIO_REPRE_1") = calFecPoderNotario1.Fecha
                    drContrato("DES_NOTARIO_REPRE_1") = ""
                    drContrato("NOM_NOTARIO_REPRE_1") = nombreNotario1
                End If

            Else

                drContrato("COD_CONTACTO_REPRE_1") = "0"
                drContrato("IDENTIFICADOR_REPRE_1") = ""
                drContrato("CARGO_REPRE_1") = ""
                drContrato("ID_PROVINCIA_REPRE_1") = ""
                drContrato("ID_POBLACION_REPRE_1") = ""
                drContrato("PROTOCOLO_REPRE_1") = ""
                drContrato("FEC_NOTARIO_REPRE_1") = Date.MinValue
                drContrato("DES_NOTARIO_REPRE_1") = ""
                drContrato("NOM_NOTARIO_REPRE_1") = ""

            End If

            If Not String.IsNullOrEmpty(ccdSegundoRepresentante.Codigo) Then

                Dim nombreNotario2 As String = ""

                nombreNotario2 = String.Concat(txtCtrApellido1Notario2.Text.Trim.ToUpper(CultureInfoSpain), "|", txtCtrApellido2Notario2.Text.Trim.ToUpper(CultureInfoSpain), "|", txtCtrNombreNotario2.Text.Trim.ToUpper(CultureInfoSpain)).ToString(CultureInfoSpain)

                If chkTextoNotario2.Checked Then
                    drContrato("COD_CONTACTO_REPRE_2") = ObtenerValorDeCcd(ccdSegundoRepresentante, "COD_CONTACTO")
                    drContrato("IDENTIFICADOR_REPRE_2") = txtCtrIdentificadorRepresentante2.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("CARGO_REPRE_2") = txtCtrCargoRepresentante2.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("ID_PROVINCIA_REPRE_2") = ""
                    drContrato("ID_POBLACION_REPRE_2") = ""
                    drContrato("PROTOCOLO_REPRE_2") = ""
                    drContrato("FEC_NOTARIO_REPRE_2") = Date.MinValue
                    drContrato("DES_NOTARIO_REPRE_2") = txtTextoNotario2.Text
                    drContrato("NOM_NOTARIO_REPRE_2") = ""
                Else
                    drContrato("COD_CONTACTO_REPRE_2") = ObtenerValorDeCcd(ccdSegundoRepresentante, "COD_CONTACTO")
                    drContrato("IDENTIFICADOR_REPRE_2") = txtCtrIdentificadorRepresentante2.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("CARGO_REPRE_2") = txtCtrCargoRepresentante2.Text.Trim.ToUpper(CultureInfoSpain)
                    drContrato("ID_PROVINCIA_REPRE_2") = cmbProvinciaNotario2.SelectedValue
                    drContrato("ID_POBLACION_REPRE_2") = ccdCtrPoblacionNotario2.Codigo
                    drContrato("PROTOCOLO_REPRE_2") = txtCtrProtocoloNotario2.Text.Trim
                    drContrato("FEC_NOTARIO_REPRE_2") = calFecPoderNotario2.Fecha
                    drContrato("DES_NOTARIO_REPRE_2") = ""
                    drContrato("NOM_NOTARIO_REPRE_2") = nombreNotario2
                End If

            Else

                drContrato("COD_CONTACTO_REPRE_2") = "0"
                drContrato("IDENTIFICADOR_REPRE_2") = ""
                drContrato("CARGO_REPRE_2") = ""
                drContrato("ID_PROVINCIA_REPRE_2") = ""
                drContrato("ID_POBLACION_REPRE_2") = ""
                drContrato("PROTOCOLO_REPRE_2") = ""
                drContrato("FEC_NOTARIO_REPRE_2") = Date.MinValue
                drContrato("DES_NOTARIO_REPRE_2") = ""
                drContrato("NOM_NOTARIO_REPRE_2") = ""

            End If

            If chkFormBonif.Checked AndAlso
                (String.Compare(txtTipoContrato.Text, "Actividades Específicas", StringComparison.InvariantCultureIgnoreCase) = 0 OrElse
                 String.Compare(txtTipoContrato.Text, "Bolsa de Horas", StringComparison.InvariantCultureIgnoreCase) = 0) Then
                drContrato("IND_FORM_BONIF") = "S"
            Else
                drContrato("IND_FORM_BONIF") = "N"
            End If

            If chkDatosFACE.Checked Then
                drContrato("IND_DATOS_FACE") = "S"
                drContrato("DES_ORGANO_GESTOR") = txtOrganoGestor.Text
                drContrato("DES_UNIDAD_TRAMITADORA") = txtUnidadTramitadora.Text
                drContrato("DES_OFICINA_CONTABLE") = txtOficinaContable.Text
                drContrato("DES_ORGANO_PROPONENTE") = txtOrganoProponente.Text
            Else
                drContrato("IND_DATOS_FACE") = "N"
            End If

            Dim diaPago As String
            Dim diaPagoValor As Integer

            diaPago = txtdiapago.Text

            If diaPago <> "" Then
                diaPagoValor = CInt(txtdiapago.Text)
                If diaPagoValor > 0 AndAlso diaPagoValor <= 31 Then
                    drContrato("DIAPAGO") = diaPagoValor
                Else
                    drContrato("DIAPAGO") = Nothing
                End If
            Else
                drContrato("DIAPAGO") = Nothing
            End If

            drContrato("CIFPAGADOR") = ccdCifPagador.Codigo

            drContrato("IND_F_DESGL") = MetodosAux.CheckAString(chkFact_U_DESGL)

            If (hdnPresupuestoQS.Value = "S" OrElse hdnPresupuestoTebex.Value = "S" OrElse hdnPresupuestoMedycsa.Value = "S") Then
                drContrato("NOM_CONTACTO_QS") = txtPersonaFilial.Text
                drContrato("EMAIL_CONTACTO_QS") = txtEmailFilial.Text
                drContrato("TEL_CONTACTO_QS") = txtTelefonoFilial.Text

                drContrato("IND_PEDIDO_QS") = MetodosAux.CheckAString(rfnchkpedido)
                drContrato("IND_CERRADO_QS") = MetodosAux.CheckAString(rfnchkcerrado)
            End If

            If (hdnPresupuestoQPPortugal.Value = "S") Then
                drContrato("NOM_CONTACTO_QS") = txtPersonaFilial.Text
                drContrato("EMAIL_CONTACTO_QS") = txtEmailFilial.Text
                drContrato("TEL_CONTACTO_QS") = txtTelefonoFilial.Text

                drContrato("DES_DOMI_PORTUGAL") = txtDomicilioFacturacionFilial.Text
                drContrato("PROV_PORTUGAL") = txtProvinciaFilial.Text
                drContrato("POBLA_PORTUGAL") = txtPoblacionFilial.Text
                drContrato("CP_PORTUGAL") = txtCPFilial.Text

                drContrato("IND_PEDIDO_QS") = MetodosAux.CheckAString(rfnchkpedido)
                drContrato("IND_CERRADO_QS") = MetodosAux.CheckAString(rfnchkcerrado)

            End If

            If (hdnPresupuestoQPPeru.Value = "S") Then
                drContrato("NOM_CONTACTO_QS") = txtPersonaFilial.Text
                drContrato("EMAIL_CONTACTO_QS") = txtEmailFilial.Text
                drContrato("TEL_CONTACTO_QS") = txtTelefonoFilial.Text

                drContrato("DES_DOMI_PORTUGAL") = txtDomicilioFacturacionFilial.Text
                drContrato("PROV_PORTUGAL") = txtProvinciaFilial.Text
                drContrato("POBLA_PORTUGAL") = txtPoblacionFilial.Text

                drContrato("IND_PEDIDO_QS") = MetodosAux.CheckAString(rfnchkpedido)
                drContrato("IND_CERRADO_QS") = MetodosAux.CheckAString(rfnchkcerrado)

            End If

            drContrato("ID_LINEA_PRODUCTO") = ddllineaproducto.SelectedValue
            drContrato("ID_IDIOMA") = ddlidioma.SelectedItem.Value

            drContrato("ID_TIP_TARIF") = ObtenerTarifaControl()
        Catch ex As Exception
            Traces.TrackException(ex, tc, pageName, "Error al RellenarDatosContrato()")
        End Try

    End Sub

    Private Function GuardaContrato() As Boolean

        Dim erroresTryParse As Boolean = True
        Try

            If hfGrabar.Value = 1 Then
                MostrarMensaje("Hay productos no compatibles con la linea de productos actual. El contrato no se guardará.", TEXTO_ERROR)
                Return False
            End If

            If Not ValidacionesDatosFace() Then
                Return False
            End If

            If Not ValidarEmails(txtEmailEnvFact.Text.Trim) OrElse (Not String.IsNullOrEmpty(txtEmailDS.Text) AndAlso Not ValidarEmail(txtEmailDS.Text.Trim)) Then
                MostrarMensaje("No se ha modificado el Contrato, el Email de envío de facturas o el Email del cliente no son válidos.", "Error")
                Return False
            End If

            Dim wsContratacion As New WsContratacion.WsContratacion

            Dim dsContrato As New DataSet
            Dim dtContrato As New DataTable
            Dim drContrato As DataRow

            ColumnasDtContrato(dtContrato)
            drContrato = dtContrato.NewRow
            RellenarDatosContrato(drContrato)
            dtContrato.Rows.Add(drContrato)
            dsContrato.Tables.Add(dtContrato.Copy())

            Dim bResultado As Boolean = False

            bResultado = wsContratacion.ModificaContrato(dsContrato.Tables(0), Usuario.Login)

            Dim bChkModMTAux As Boolean
            If (chkModMT.Checked AndAlso txtModMTDescuento.Text <> "" AndAlso CDbl(txtModMTDescuento.Text) > 0) Then
                bChkModMTAux = True
            Else
                bChkModMTAux = False
            End If

            If (bResultado AndAlso (String.Compare(ddlCtrEstadoContrato.SelectedValue.ToString(CultureInfoSpain).Trim, "V", StringComparison.InvariantCultureIgnoreCase) = 0) AndAlso
                (ddlCtrEstadoContrato.SelectedValue <> ddlCtrEstadoContratoOculto.SelectedValue) AndAlso
                (chkModST.Checked OrElse chkModHI.Checked OrElse chkModEP.Checked OrElse bChkModMTAux)) Then

                Dim dHTContrato, dHMContrato As Decimal
                erroresTryParse = Decimal.TryParse((txtModHorTecDescuento.Text.Trim), dHTContrato)
                erroresTryParse = Decimal.TryParse((txtModHorMedDescuento.Text.Trim), dHMContrato)

                wsContratacion.ReparteHorasSegunTarifaOficialModalidades(hfidCliente.Value.ToString(CultureInfoSpain).Trim, txtCtrIdContrato.Text,
                hfCodEMPPRL.Value.ToString(CultureInfoSpain), ccdTarifaModalidad.Codigo, chkModHI.Checked, chkModST.Checked,
                chkModEP.Checked, bChkModMTAux, dHTContrato, dHMContrato)

            End If
            Dim idContrato As Integer = CInt(drContrato("ID_CONTRATO"))
            Dim codContrato As Integer = CInt(drContrato("COD_CONTRATO"))
            If Not EnvioAFiliales(dsContrato, drContrato) Then
                Return False
            End If

            If bResultado AndAlso HayQueActualizarEnSalesforce() Then
                ActualizarContratoSaleForce(idContrato, Usuario.Login.ToString(CultureInfoSpain))
            End If

            Dim idioma As String = IIf(String.IsNullOrEmpty(ddlidioma.SelectedValue), "1", ddlidioma.SelectedValue)
            If ddlCtrEstadoContrato.SelectedValue = "V" AndAlso idioma <> hfidIdioma.Value Then
                ActualizarIdiomaAsignacionMedica(codContrato, ddlidioma.SelectedValue, Usuario.Login)
            End If

            If bResultado Then
                hfCpCentro.Value = cmbCPEnvFact.SelectedValue
                AddLoadScript("ActualizaDatosContrato();")
            Else
                MostrarMensaje("Error al guardar el Contrato. Revise los domicilios de cliente y los datos obligatorios.", "Error")
            End If

            Return bResultado

        Catch ex As Exception
            Traces.TrackException(ex, tc, pageName, "Se ha producido un error al guardar el contrato")
            MostrarMensaje("Error al guardar el Contrato", "Error")
            Return False
            Throw
        End Try

    End Function

    Private Function EnvioAFiliales(dsContrato As DataSet, drContrato As DataRow) As Boolean
        'ENVÍO A QSAFETY
        Using wsContratacion As New WsContratacion.WsContratacion
            Dim idContrato As Integer = CInt(drContrato("ID_CONTRATO"))
            Dim codContrato As Integer = CInt(drContrato("COD_CONTRATO"))
            Dim email = ""
            If ccdCtrRespCaptacion.InfoExtra.Count > 0 AndAlso Not chkGestionInterna.Checked Then
                email = ccdCtrRespCaptacion.InfoExtra("DES_EMAIL").ToString(CultureInfoSpain).Trim
            End If

            Try
                If (ddlCtrEstadoContrato.SelectedValue = "E") Then
                    IntegracionQsafety.EnvioQsafety.Handle(tc, idContrato)
                End If
            Catch ex As ArgumentNullException

                RevertirEstadoContratoEnviadoAQsafety(wsContratacion, dsContrato, drContrato)
                MostrarMensaje("Error al enviar contrato a QSafety. Contrato guardado.")
                RELOAD()
                Return False
            Catch ex As Exception

                RevertirEstadoContratoEnviadoAQsafety(wsContratacion, dsContrato, drContrato)
                MostrarMensaje("Error al enviar contrato a QSafety. Contrato guardado.")
                RELOAD()
                Return False
            End Try

            'ENVÍO A TEBEX
            Try
                If (ddlCtrEstadoContrato.SelectedValue = "X") Then
                    ConstruirEmailTexbex(codContrato, email)
                End If
            Catch ex As ArgumentNullException
                MostrarMensaje("Error al enviar contrato a Tebex. Contrato guardado.")
                Return False
            Catch ex As Exception
                RELOAD()
                MostrarMensaje("Error al enviar contrato a Tebex. Contrato guardado.")
                Return False
            End Try

            'ENVÍO A QP-PORTUGAL
            Try
                If (ddlCtrEstadoContrato.SelectedValue = "Q") Then
                    ConstruirEmailQPPortugal(codContrato, empresaFilial.Text, email)
                End If
            Catch ex As ArgumentNullException
                MostrarMensaje("Error al enviar contrato a QP-Portugal. Contrato guardado.")
                Return False
            Catch ex As Exception
                RELOAD()
                MostrarMensaje("Error al enviar contrato a QP-Portugal. Contrato guardado.")
                Return False
            End Try

            'ENVÍO A MEDYCSA
            Try
                If (ddlCtrEstadoContrato.SelectedValue = "M") Then
                    IntegracionQsafety.EnvioQsafety.Handle(tc, idContrato)
                End If
            Catch ex As ArgumentNullException

                RevertirEstadoContratoEnviadoAQsafety(wsContratacion, dsContrato, drContrato)
                MostrarMensaje("Error al enviar contrato a Medycsa. Contrato guardado.")
                Return False
            Catch ex As Exception

                RevertirEstadoContratoEnviadoAQsafety(wsContratacion, dsContrato, drContrato)
                RELOAD()
                MostrarMensaje("Error al enviar contrato a Medycsa. Contrato guardado.")
                Return False
            End Try

            'ENVÍO A QP-PERÚ
            Try
                If (ddlCtrEstadoContrato.SelectedValue = "Y") Then
                    ConstruirEmailQPPeru(codContrato, empresaFilial.Text, email)
                End If
            Catch ex As ArgumentNullException
                MostrarMensaje("Error al enviar contrato a QP-Perú. Contrato guardado.")
                Return False
            Catch ex As Exception
                RELOAD()
                MostrarMensaje("Error al enviar contrato a QP-Perú. Contrato guardado.")
                Return False
            End Try
        End Using

        Return True
    End Function

    Private Function HayQueActualizarEnSalesforce() As Boolean
        Return IntegracionSaleForce.SalesForceHabilitado _
                    AndAlso (ddlCtrEstadoContrato.SelectedValue <> ddlCtrEstadoContratoOculto.SelectedValue) _
                    OrElse (ccdCtrRespCaptacion.Codigo <> hfCodPersonaComerc.Value _
                    AndAlso (ccdCtrRespCaptacion.Codigo <> hfGestionInterna.Value _
                    OrElse (ccdCtrRespCaptacion.Codigo = hfGestionInterna.Value AndAlso hfCodPersonaComerc.Value <> "")))
    End Function

    Private Function RevertirEstadoContratoEnviadoAQsafety(wsContratacion As WsContratacion.WsContratacion, dsContrato As DataSet, drContrato As DataRow) As DataRow
        dsContrato.Tables(0).Rows(0)("IND_ESTADO") = ddlCtrEstadoContratoOculto.SelectedValue
        drContrato.AcceptChanges()
        ddlCtrEstadoContrato.SelectedValue = ddlCtrEstadoContratoOculto.SelectedValue
        wsContratacion.ModificaContrato(dsContrato.Tables(0), Usuario.Login)

        Return drContrato
    End Function

    Private Function ActualizarContratoSaleForce(ByVal idContrato As Integer, ByVal sNomLog As String) As ResultadoSaleforceApi
        Dim resultado As New ResultadoSaleforceApi
        Try
            resultado = IntegracionSaleForce.ModificarContratoSalesforce(idContrato, sNomLog)
        Catch ex As Exception

            Throw New Exception("No se pudo actualizar el contrato en SaleForce ")
        End Try

        Return resultado
    End Function

    Private Function ActualizarIdiomaAsignacionMedica(codContrato As Integer, codIdioma As String, nomLogin As String) As Boolean
        Using contratosWebServiceAjax As New ContratosWebServiceAjax()
            Return contratosWebServiceAjax.CambiarIdiomaAsignacionMedica(codContrato, codIdioma, nomLogin)
        End Using
    End Function

    Private Sub ColumnasDtContrato(ByRef dtContrato As DataTable)

        dtContrato.Columns.Add("ID_CLIENTE")
        dtContrato.Columns.Add("ID_CONTRATO")
        dtContrato.Columns.Add("COD_CONTRATO")
        dtContrato.Columns.Add("IND_ESTADO")
        dtContrato.Columns.Add("FEC_FIRMA")
        dtContrato.Columns.Add("COD_CENTRO_GEST")
        dtContrato.Columns.Add("DIRECTIVO_1")
        dtContrato.Columns.Add("DIRECTIVO_2")
        dtContrato.Columns.Add("PODER_1")
        dtContrato.Columns.Add("PODER_2")
        dtContrato.Columns.Add("COD_COLABORADOR")
        dtContrato.Columns.Add("POR_COMISION")
        dtContrato.Columns.Add("FEC_VINCULACION")
        dtContrato.Columns.Add("COD_PERSONA_COMERC1")
        dtContrato.Columns.Add("COD_PERSONA_COMERC2")
        dtContrato.Columns.Add("FEC_BAJA")
        dtContrato.Columns.Add("FEC_BAJA_FUTURA")
        dtContrato.Columns.Add("IND_BAJA_FUTURA")
        dtContrato.Columns.Add("ID_CAUSA_BAJA")
        dtContrato.Columns.Add("DES_OBSERV_BAJA")
        dtContrato.Columns.Add("FEC_ULT_RENOV")
        dtContrato.Columns.Add("FEC_TERMINADO")
        dtContrato.Columns.Add("IND_IPC")
        dtContrato.Columns.Add("FEC_IPC")
        dtContrato.Columns.Add("IND_CARTERA")
        dtContrato.Columns.Add("FEC_INICIO_FACT")
        dtContrato.Columns.Add("IND_FACT_LIBRE")
        dtContrato.Columns.Add("IND_FACT_ELECTRONICA")
        dtContrato.Columns.Add("IND_GRAN_EMP_CONT")
        dtContrato.Columns.Add("IND_CAPT_AAEE")
        dtContrato.Columns.Add("IND_FACT_PERIODO_VENC")
        dtContrato.Columns.Add("IND_FACT_MOD_CENT")
        dtContrato.Columns.Add("IND_FACT_ANA_CENT")
        dtContrato.Columns.Add("IND_FACT_RECO_CENT")
        dtContrato.Columns.Add("FEC_FACT_MOD_CENT")
        dtContrato.Columns.Add("FEC_FACT_ANA_CENT")
        dtContrato.Columns.Add("FEC_FACT_RECO_CENT")
        dtContrato.Columns.Add("IND_ENV_AL_CENTRO")
        dtContrato.Columns.Add("IND_MOD_FACTURA")
        dtContrato.Columns.Add("IND_TIPO_FACTURA")
        dtContrato.Columns.Add("IND_PLAZO_VENC")
        dtContrato.Columns.Add("NOM_TITULAR")
        dtContrato.Columns.Add("COD_CTA_BANCARIA")
        dtContrato.Columns.Add("ID_TITULAR")
        dtContrato.Columns.Add("DES_PERSONA_ATENC")
        dtContrato.Columns.Add("DES_EMAIL_ENVIO")
        dtContrato.Columns.Add("ID_PROVINCIA_DOMIC")
        dtContrato.Columns.Add("ID_POBLACION_DOMIC")
        dtContrato.Columns.Add("CP_DOMIC")
        dtContrato.Columns.Add("DIRECCION_DOMIC")
        dtContrato.Columns.Add("TELEFONO_DOMIC")
        dtContrato.Columns.Add("FAX_DOMIC")
        dtContrato.Columns.Add("COD_ACTIVIDAD")
        dtContrato.Columns.Add("ID_ACTIVIDAD")

        dtContrato.Columns.Add("COD_CONTACTO_REPRE_1")
        dtContrato.Columns.Add("IDENTIFICADOR_REPRE_1")
        dtContrato.Columns.Add("CARGO_REPRE_1")
        dtContrato.Columns.Add("ID_PROVINCIA_REPRE_1")
        dtContrato.Columns.Add("ID_POBLACION_REPRE_1")
        dtContrato.Columns.Add("PROTOCOLO_REPRE_1")
        dtContrato.Columns.Add("FEC_NOTARIO_REPRE_1")
        dtContrato.Columns.Add("DES_NOTARIO_REPRE_1")
        dtContrato.Columns.Add("NOM_NOTARIO_REPRE_1")
        dtContrato.Columns.Add("IND_RECORDATORIO_IPC")
        dtContrato.Columns.Add("COD_CONTACTO_REPRE_2")
        dtContrato.Columns.Add("IDENTIFICADOR_REPRE_2")
        dtContrato.Columns.Add("CARGO_REPRE_2")
        dtContrato.Columns.Add("ID_PROVINCIA_REPRE_2")
        dtContrato.Columns.Add("ID_POBLACION_REPRE_2")
        dtContrato.Columns.Add("PROTOCOLO_REPRE_2")
        dtContrato.Columns.Add("FEC_NOTARIO_REPRE_2")
        dtContrato.Columns.Add("DES_NOTARIO_REPRE_2")
        dtContrato.Columns.Add("NOM_NOTARIO_REPRE_2")
        dtContrato.Columns.Add("ID_DOMI_SOCIAL")
        dtContrato.Columns.Add("ID_DOMI_ENVIO")
        dtContrato.Columns.Add("IND_FORM_BONIF")
        dtContrato.Columns.Add("CONTRATO_ANTIGUO")
        dtContrato.Columns.Add("DES_INCIDENCIAS")
        dtContrato.Columns.Add("DES_EMAIL_SOCIAL")
        dtContrato.Columns.Add("FEC_BAJA_ESP")
        dtContrato.Columns.Add("DES_REF_FACTURA")
        dtContrato.Columns.Add("IND_DATOS_FACE")
        dtContrato.Columns.Add("DES_ORGANO_GESTOR")
        dtContrato.Columns.Add("DES_UNIDAD_TRAMITADORA")
        dtContrato.Columns.Add("DES_OFICINA_CONTABLE")
        dtContrato.Columns.Add("DES_ORGANO_PROPONENTE")
        dtContrato.Columns.Add("DIAPAGO")
        dtContrato.Columns.Add("CIFPAGADOR")
        dtContrato.Columns.Add("IND_F_DESGL")
        dtContrato.Columns.Add("IND_FACT_ANALITICA")
        dtContrato.Columns.Add("IND_FACT_LIBRE_F")
        dtContrato.Columns.Add("IND_FACT_LIBRE_V")
        dtContrato.Columns.Add("IND_FACT_REG")
        dtContrato.Columns.Add("IND_RET_PDF_F")
        dtContrato.Columns.Add("IND_RET_PDF_V")
        dtContrato.Columns.Add("NUM_PEDIDO_F")
        dtContrato.Columns.Add("NUM_PEDIDO_V")


        dtContrato.Columns.Add("IND_FL_REC")
        dtContrato.Columns.Add("IND_FL_ANA")
        dtContrato.Columns.Add("IND_FL_VSI")
        dtContrato.Columns.Add("IND_F_COMI")


        dtContrato.Columns.Add("FEC_INI_SUSP")
        dtContrato.Columns.Add("FEC_FIN_SUSP")

        dtContrato.Columns.Add("IND_RENOVABLE")

        dtContrato.Columns.Add("IND_SERES")
        dtContrato.Columns.Add("IND_FIRMA")

        dtContrato.Columns.Add("NOM_CONTACTO_QS")
        dtContrato.Columns.Add("EMAIL_CONTACTO_QS")
        dtContrato.Columns.Add("TEL_CONTACTO_QS")
        dtContrato.Columns.Add("IND_PEDIDO_QS")
        dtContrato.Columns.Add("IND_CERRADO_QS")

        dtContrato.Columns.Add("IND_AAPP")

        dtContrato.Columns.Add("DES_DOMI_PORTUGAL")
        dtContrato.Columns.Add("PROV_PORTUGAL")
        dtContrato.Columns.Add("POBLA_PORTUGAL")
        dtContrato.Columns.Add("CP_PORTUGAL")

        dtContrato.Columns.Add("ID_LINEA_PRODUCTO")
        dtContrato.Columns.Add("DES_OBS_MED")
        dtContrato.Columns.Add("DES_OBS_TEC")
        dtContrato.Columns.Add("IND_F_UNI_VSI")
        dtContrato.Columns.Add("CONTRATO_NUEVO")
        dtContrato.Columns.Add("ID_IDIOMA")
        dtContrato.Columns.Add("ID_TIP_TARIF")
        dtContrato.Columns.Add("IND_CANCELACION_UM")
    End Sub

#End Region

#Region "Métodos de Utilidades"

    ''' <summary>
    ''' Comprueba Firma digital y establece estado de firma.
    ''' </summary>
    ''' <remarks></remarks>
    Private Function ComprobarFirmaDigitalContrato(detallesContrato As DetallesContrato) As List(Of DocumentoContrato)
        Dim firmaIniciada As Boolean = False
        Dim contratosEnFirma As IReadOnlyList(Of String)
        Dim contratosWebServiceAjax As ContratosWebServiceAjax = New ContratosWebServiceAjax()
        Dim documentsWebServiceAjax As DocumentsWebServiceAjax = New DocumentsWebServiceAjax()
        Dim estadoContrato As String
        Dim regionCliente As Integer
        Dim datosDigital As List(Of DocumentoContrato)

        datosDigital = documentsWebServiceAjax.GetContractDocuments(CInt(txtCtrIdContrato.Text))
        If detallesContrato Is Nothing Then
            estadoContrato = ddlCtrEstadoContrato.SelectedValue
        Else
            estadoContrato = detallesContrato.State
            regionCliente = detallesContrato.Customer.address.regionId
        End If

        If (ddlCtrEstadoContratoOculto.SelectedValue <> "F" OrElse ddlCtrEstadoContrato.SelectedValue <> "P") Then
            If ddlCtrEstadoContrato.SelectedValue = "C" OrElse ddlCtrEstadoContrato.SelectedValue = "P" OrElse ddlCtrEstadoContrato.SelectedValue = "O" Then
                ddlCtrEstadoContrato.SelectedValue = estadoContrato
                ddlCtrEstadoContratoOculto.SelectedValue = estadoContrato
            Else
                estadoContrato = ddlCtrEstadoContrato.SelectedValue
            End If
        End If

        If datosDigital IsNot Nothing AndAlso datosDigital.Count > 0 Then
            contratosEnFirma = contratosWebServiceAjax.GetPendingSignature(txtCtrIdContrato.Text)
            If contratosEnFirma IsNot Nothing AndAlso contratosEnFirma.Count > 0 Then
                firmaIniciada = True
            End If

            txtEstadoDocumento.Text = ""

            Dim firmaEnTiempoReal As FirmaEnTiempoReal = contratosWebServiceAjax.GetCurrentSignInfo(txtCtrIdContrato.Text)
            If firmaEnTiempoReal IsNot Nothing AndAlso Not String.IsNullOrEmpty(firmaEnTiempoReal.state) Then
                txtEstadoDocumento.Text = GetEstadoContrato(firmaEnTiempoReal.state)
            End If

            For Each documento As DocumentoContrato In datosDigital
                If IsNothing(documento.Web) Then
                    documento.Web = False
                End If

                If Not documento.FileName.Contains("Cargo") Then
                    Dim estado As EstadoFirma

                    calCtrFecGeneracion.Fecha = documento.CreateDate
                    documento.MuestraEliminar = EsEliminable(documento.FileName, documento.User)
                    documento.MuestraCancelar = False
                    documento.MuestraFirma = False

                    estado = contratosWebServiceAjax.GetStatus(documento.ContractId, documento.DocumentId)
                    If Not IsNothing(estado) Then
                        documento.SendToOtpDate = estado.sentDate
                    End If

                    If estadoContrato = "O" Then
                        If firmaIniciada AndAlso contratosEnFirma.Contains(documento.DocumentId) Then
                            documento.MuestraCancelar = True
                            documento.MuestraEliminar = False
                            If firmaEnTiempoReal IsNot Nothing AndAlso documento.DocumentId.Equals(firmaEnTiempoReal.documentId, StringComparison.InvariantCulture) AndAlso firmaEnTiempoReal.state = "S" Then
                                documento.MuestraCancelar = False
                            End If
                        End If
                    ElseIf estadoContrato = "P" Then
                        documento.MuestraCancelar = False
                        documento.MuestraFirma = False
                        If Not firmaIniciada AndAlso documento.IsSignableByOtp Then
                            documento.MuestraFirma = documento.SignType = "OTP" OrElse documento.SignType = ""
                        End If

                        If Not IsNothing(estado) Then
                            txtEstadoDocumento.Text = GetEstadoContrato(estado.state)
                        End If
                    End If
                End If
            Next
        End If

        Return datosDigital
    End Function

#End Region

#End Region

    Private Sub InfContrato()

        Try

            cambiaEstado = False

            Dim dsDatosDocumentoContrato As New DataSet

            Using wsContratacion As New WsContratacion.WsContratacion
                dsDatosDocumentoContrato = descomprimirDataset(wsContratacion.ObtenerDatosDocumentoContrato(txtCtrIdContrato.Text, Usuario.Login))
            End Using

            If dsDatosDocumentoContrato IsNot Nothing AndAlso PuedeGenerarDocFirmaDirectivo() Then
                GeneraDocumentoContrato(dsDatosDocumentoContrato)

                hfDCCGenerado.Value = "N"
                Dim dtDatosDocumentoContrato As New DataTable

                dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)

                If dtDatosDocumentoContrato IsNot Nothing AndAlso dtDatosDocumentoContrato.Rows.Count = 1 AndAlso dtDatosDocumentoContrato.Rows(0)("REF_MANDATO").ToString.Trim <> "" Then
                    hfDCCGenerado.Value = "S"
                End If

                cambiaEstado = True
            End If


        Catch ex As Exception
            cambiaEstado = False
            Me.MostrarMensaje(ex.ToString, "Error al generar el documento")
        End Try

    End Sub


    Private Sub ComprobarCuenta()

        Try

            Dim dsDatosDocumentoContrato As New DataSet

            Using wsContratacion As New WsContratacion.WsContratacion
                dsDatosDocumentoContrato = descomprimirDataset(wsContratacion.ObtenerDatosDocumentoContrato(txtCtrIdContrato.Text, Usuario.Login))
            End Using

            If dsDatosDocumentoContrato IsNot Nothing Then

                Dim dtDatosDocumentoContrato As New DataTable
                dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)

                If dtDatosDocumentoContrato IsNot Nothing AndAlso dtDatosDocumentoContrato.Rows.Count = 1 AndAlso dtDatosDocumentoContrato.Rows(0)("REF_MANDATO").ToString.Trim = "0" Then
                    Me.MostrarMensaje("La cuenta bancaria se ha recogido del contrato de modalidad de este cliente. Si la modificas, recuerda que debes solicitar mandato SEPA.", TEXTO_INFORMACION)
                End If

            End If


        Catch ex As Exception
            Me.MostrarMensaje(ex.ToString, "Error al comprobar la cuenta.")
            Throw
        End Try

    End Sub

    Private Sub tlbCtrBarraPrincipal_BotonGuardarClick() Handles tlbCtrBarraPrincipal.BotonGuardarClick
        Try
            Dim lblLegendCtrContrato As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrContrato"), HtmlGenericControl)
            Dim lblCtrCodContrato As HtmlGenericControl = CType(Me.FindControl("lblCtrCodContrato"), HtmlGenericControl)
            Dim lblCodContratoAsociado As HtmlGenericControl = CType(Me.FindControl("lblCodContratoAsociado"), HtmlGenericControl)
            Dim lblContratoSAP As HtmlGenericControl = CType(Me.FindControl("lblContratoSAP"), HtmlGenericControl)
            Dim lblCtrEstadoContrato As HtmlGenericControl = CType(Me.FindControl("lblCtrEstadoContrato"), HtmlGenericControl)
            Dim lblCtrFecTerminado As HtmlGenericControl = CType(Me.FindControl("lblCtrFecTerminado"), HtmlGenericControl)
            Dim lblCtrFecEstadoContrato As HtmlGenericControl = CType(Me.FindControl("lblCtrFecEstadoContrato"), HtmlGenericControl)
            Dim lblCtrFecFirma1 As HtmlGenericControl = CType(Me.FindControl("lblCtrFecFirma1"), HtmlGenericControl)
            Dim lblEstadoPresupuesto As HtmlGenericControl = CType(Me.FindControl("lblEstadoPresupuesto"), HtmlGenericControl)
            Dim lblCtrFecEstadoPresupuesto As HtmlGenericControl = CType(Me.FindControl("lblCtrFecEstadoPresupuesto"), HtmlGenericControl)
            Dim lblImporteTotalContrato As HtmlGenericControl = CType(Me.FindControl("lblImporteTotalContrato"), HtmlGenericControl)
            Dim lblTipoContrato As HtmlGenericControl = CType(Me.FindControl("lblTipoContrato"), HtmlGenericControl)
            Dim lblidioma As HtmlGenericControl = CType(Me.FindControl("lblidioma"), HtmlGenericControl)
            Dim lblEstadoDocumento As HtmlGenericControl = CType(Me.FindControl("lblEstadoDocumento"), HtmlGenericControl)
            Dim lblCtrFecGeneracion As HtmlGenericControl = CType(Me.FindControl("lblCtrFecGeneracion"), HtmlGenericControl)
            Dim lblCtrVersionDocumento As HtmlGenericControl = CType(Me.FindControl("lblCtrVersionDocumento"), HtmlGenericControl)
            Dim lblCtrCodPresupuesto As HtmlGenericControl = CType(Me.FindControl("lblCtrCodPresupuesto"), HtmlGenericControl)
            Dim lblRazonSocial1 As HtmlGenericControl = CType(Me.FindControl("lblRazonSocial1"), HtmlGenericControl)
            Dim lblCentGest As HtmlGenericControl = CType(Me.FindControl("lblCentGest"), HtmlGenericControl)
            Dim lblPersonaAlta As HtmlGenericControl = CType(Me.FindControl("lblPersonaAlta"), HtmlGenericControl)
            Dim lblObservaciones As HtmlGenericControl = CType(Me.FindControl("lblObservaciones"), HtmlGenericControl)
            Dim lblObservacionesTec As HtmlGenericControl = CType(Me.FindControl("lblObservacionesTec"), HtmlGenericControl)
            Dim lblObservacionesMed As HtmlGenericControl = CType(Me.FindControl("lblObservacionesMed"), HtmlGenericControl)
            Dim lblHorasPerfilesMedycsa As HtmlGenericControl = CType(Me.FindControl("lblHorasPerfilesMedycsa"), HtmlGenericControl)
            Dim lblAltaGrupoCliente As HtmlGenericControl = CType(Me.FindControl("lblAltaGrupoCliente"), HtmlGenericControl)
            Dim lblCeco As HtmlGenericControl = CType(Me.FindControl("lblCeco"), HtmlGenericControl)
            Dim lblLineaNegocio As HtmlGenericControl = CType(Me.FindControl("lblLineaNegocio"), HtmlGenericControl)
            Dim lblGestor As HtmlGenericControl = CType(Me.FindControl("lblGestor"), HtmlGenericControl)
            Dim lblDesdeContrato As HtmlGenericControl = CType(Me.FindControl("lblDesdeContrato"), HtmlGenericControl)
            Dim lblListadoContratos As HtmlGenericControl = CType(Me.FindControl("lblListadoContratos"), HtmlGenericControl)
            'Dim lblLegendDesdeContrato As HtmlGenericControl = CType(Me.FindControl("lblLegendDesdeContrato"), HtmlGenericControl)
            Dim lblMigrarContactos As HtmlGenericControl = CType(Me.FindControl("lblMigrarContactos"), HtmlGenericControl)
            Dim lblMigrarFirmantesCliente As HtmlGenericControl = CType(Me.FindControl("lblMigrarFirmantesCliente"), HtmlGenericControl)
            Dim lblMigrarFirmantesSPFM As HtmlGenericControl = CType(Me.FindControl("lblMigrarFirmantesSPFM"), HtmlGenericControl)
            Dim lblLegendDatosCliente As HtmlGenericControl = CType(Me.FindControl("lblLegendDatosCliente"), HtmlGenericControl)
            Dim lblRazonSocial As HtmlGenericControl = CType(Me.FindControl("lblRazonSocial"), HtmlGenericControl)
            Dim lblActividad As HtmlGenericControl = CType(Me.FindControl("lblActividad"), HtmlGenericControl)
            Dim lblDomicilioSocial As HtmlGenericControl = CType(Me.FindControl("lblDomicilioSocial"), HtmlGenericControl)
            Dim lblGrabarDomiSocial As HtmlGenericControl = CType(Me.FindControl("lblGrabarDomiSocial"), HtmlGenericControl)
            Dim lblAltaNombreCompletoSocial As HtmlGenericControl = CType(Me.FindControl("lblAltaNombreCompletoSocial"), HtmlGenericControl)
            Dim lblAltaNombreSocial As HtmlGenericControl = CType(Me.FindControl("lblAltaNombreSocial"), HtmlGenericControl)
            Dim lblAltaApellido1Social As HtmlGenericControl = CType(Me.FindControl("lblAltaApellido1Social"), HtmlGenericControl)
            Dim lblAltaApellido2Social As HtmlGenericControl = CType(Me.FindControl("lblAltaApellido2Social"), HtmlGenericControl)
            Dim btninsertarPrueba As HtmlGenericControl = CType(Me.FindControl("btninsertarPrueba"), HtmlGenericControl)
            Dim btnrecargar As HtmlGenericControl = CType(Me.FindControl("btnrecargar"), HtmlGenericControl)
            Dim datosAsociadosFilial As HtmlGenericControl = CType(Me.FindControl("datosAsociadosFilial"), HtmlGenericControl)
            Dim FlblCodPostalCentro As HtmlGenericControl = CType(Me.FindControl("FlblCodPostalCentro"), HtmlGenericControl)
            Dim FlblPoblacion As HtmlGenericControl = CType(Me.FindControl("FlblPoblacion"), HtmlGenericControl)
            Dim FlblProvincia As HtmlGenericControl = CType(Me.FindControl("FlblProvincia"), HtmlGenericControl)
            Dim lbCosteTotalPruebasVSI As HtmlGenericControl = CType(Me.FindControl("lbCosteTotalPruebasVSI"), HtmlGenericControl)
            Dim lblActividadCentro As HtmlGenericControl = CType(Me.FindControl("lblActividadCentro"), HtmlGenericControl)
            Dim lblAltaPeligrosidad As HtmlGenericControl = CType(Me.FindControl("lblAltaPeligrosidad"), HtmlGenericControl)
            Dim lblApellido1 As HtmlGenericControl = CType(Me.FindControl("lblApellido1"), HtmlGenericControl)
            Dim lblApellido2 As HtmlGenericControl = CType(Me.FindControl("lblApellido2"), HtmlGenericControl)
            Dim lblAtencionEnvFact As HtmlGenericControl = CType(Me.FindControl("lblAtencionEnvFact"), HtmlGenericControl)
            Dim lblAtencionEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblAtencionEnvFactP"), HtmlGenericControl)
            Dim lblbajamultiple As HtmlGenericControl = CType(Me.FindControl("lblbajamultiple"), HtmlGenericControl)
            Dim lblBajaPeligrosidad As HtmlGenericControl = CType(Me.FindControl("lblBajaPeligrosidad"), HtmlGenericControl)
            Dim lblbobser As HtmlGenericControl = CType(Me.FindControl("lblbobser"), HtmlGenericControl)
            Dim lblbobser2 As HtmlGenericControl = CType(Me.FindControl("lblbobser2"), HtmlGenericControl)
            Dim lblCalle As HtmlGenericControl = CType(Me.FindControl("lblCalle"), HtmlGenericControl)
            Dim lblCalleDS As HtmlGenericControl = CType(Me.FindControl("lblCalleDS"), HtmlGenericControl)
            Dim lblCalleEnvFact As HtmlGenericControl = CType(Me.FindControl("lblCalleEnvFact"), HtmlGenericControl)
            Dim lblCalleEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblCalleEnvFactP"), HtmlGenericControl)
            Dim lblCCC As HtmlGenericControl = CType(Me.FindControl("lblCCC"), HtmlGenericControl)
            Dim lblccdPruebasExternas As HtmlGenericControl = CType(Me.FindControl("lblccdPruebasExternas"), HtmlGenericControl)
            Dim lblccdTarifaAutonomos As HtmlGenericControl = CType(Me.FindControl("lblccdTarifaAutonomos"), HtmlGenericControl)
            Dim lblccdTarifaBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblccdTarifaBolsaHoras"), HtmlGenericControl)
            Dim lblccdTarifaModalidad As HtmlGenericControl = CType(Me.FindControl("lblccdTarifaModalidad"), HtmlGenericControl)
            Dim lblccdTarifaProductos As HtmlGenericControl = CType(Me.FindControl("lblccdTarifaProductos"), HtmlGenericControl)
            Dim lblCentros As HtmlGenericControl = CType(Me.FindControl("lblCentros"), HtmlGenericControl)
            Dim lblcifpagador As HtmlGenericControl = CType(Me.FindControl("lblcifpagador"), HtmlGenericControl)
            Dim lblCodAnexo As HtmlGenericControl = CType(Me.FindControl("lblCodAnexo"), HtmlGenericControl)
            Dim lblCodContrato As HtmlGenericControl = CType(Me.FindControl("lblCodContrato"), HtmlGenericControl)
            Dim lblCodPostalCentro As HtmlGenericControl = CType(Me.FindControl("lblCodPostalCentro"), HtmlGenericControl)
            Dim lblCodPostalDS As HtmlGenericControl = CType(Me.FindControl("lblCodPostalDS"), HtmlGenericControl)
            Dim lblCodPostalEnvFact As HtmlGenericControl = CType(Me.FindControl("lblCodPostalEnvFact"), HtmlGenericControl)
            Dim lblCodPostalEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblCodPostalEnvFactP"), HtmlGenericControl)
            Dim lblCPFilial As HtmlGenericControl = CType(Me.FindControl("lblCPFilial"), HtmlGenericControl)
            Dim lblCrearAnexo As HtmlGenericControl = CType(Me.FindControl("lblCrearAnexo"), HtmlGenericControl)
            Dim lblCrearAnexoAAEE As HtmlGenericControl = CType(Me.FindControl("lblCrearAnexoAAEE"), HtmlGenericControl)
            Dim lblCrearAnexoAnalitica As HtmlGenericControl = CType(Me.FindControl("lblCrearAnexoAnalitica"), HtmlGenericControl)
            Dim lblCrearAnexoRenovacion As HtmlGenericControl = CType(Me.FindControl("lblCrearAnexoRenovacion"), HtmlGenericControl)
            Dim lblCtrApellido1Notario1 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido1Notario1"), HtmlGenericControl)
            Dim lblCtrApellido1Notario2 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido1Notario2"), HtmlGenericControl)
            Dim lblCtrApellido1Representante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido1Representante1"), HtmlGenericControl)
            Dim lblCtrApellido1Representante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido1Representante2"), HtmlGenericControl)
            Dim lblCtrApellido2Notario1 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido2Notario1"), HtmlGenericControl)
            Dim lblCtrApellido2Notario2 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido2Notario2"), HtmlGenericControl)
            Dim lblCtrApellido2Representante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido2Representante1"), HtmlGenericControl)
            Dim lblCtrApellido2Representante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrApellido2Representante2"), HtmlGenericControl)
            Dim lblCtrBajaMultiple As HtmlGenericControl = CType(Me.FindControl("lblCtrBajaMultiple"), HtmlGenericControl)
            Dim lblCtrCargoDirectivo1 As HtmlGenericControl = CType(Me.FindControl("lblCtrCargoDirectivo1"), HtmlGenericControl)
            Dim lblCtrCargoDirectivo2 As HtmlGenericControl = CType(Me.FindControl("lblCtrCargoDirectivo2"), HtmlGenericControl)
            Dim lblCtrCargoRepresentante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrCargoRepresentante1"), HtmlGenericControl)
            Dim lblCtrCargoRepresentante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrCargoRepresentante2"), HtmlGenericControl)
            Dim lblCtrCausaBaja As HtmlGenericControl = CType(Me.FindControl("lblCtrCausaBaja"), HtmlGenericControl)
            Dim lblCtrCausaBaja2 As HtmlGenericControl = CType(Me.FindControl("lblCtrCausaBaja2"), HtmlGenericControl)
            Dim lblCtrCodContratoFirma As HtmlGenericControl = CType(Me.FindControl("lblCtrCodContratoFirma"), HtmlGenericControl)
            Dim lblCtrCodPresupuestoFirma As HtmlGenericControl = CType(Me.FindControl("lblCtrCodPresupuestoFirma"), HtmlGenericControl)
            Dim lblCtrColaborador As HtmlGenericControl = CType(Me.FindControl("lblCtrColaborador"), HtmlGenericControl)
            Dim lblCtrContratoAntiguo As HtmlGenericControl = CType(Me.FindControl("lblCtrContratoAntiguo"), HtmlGenericControl)
            Dim lblCtrContratoNuevo As HtmlGenericControl = CType(Me.FindControl("lblCtrContratoNuevo"), HtmlGenericControl)
            Dim lblCtrDirectivo1 As HtmlGenericControl = CType(Me.FindControl("lblCtrDirectivo1"), HtmlGenericControl)
            Dim lblCtrDirectivo2 As HtmlGenericControl = CType(Me.FindControl("lblCtrDirectivo2"), HtmlGenericControl)
            Dim lblCtrEmailRepresentante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrEmailRepresentante1"), HtmlGenericControl)
            Dim lblCtrEmailRepresentante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrEmailRepresentante2"), HtmlGenericControl)
            Dim lblCtrEstadoContratoFirma As HtmlGenericControl = CType(Me.FindControl("lblCtrEstadoContratoFirma"), HtmlGenericControl)
            Dim lblCtrFecBaja As HtmlGenericControl = CType(Me.FindControl("lblCtrFecBaja"), HtmlGenericControl)
            Dim lblCtrFecBaja2 As HtmlGenericControl = CType(Me.FindControl("lblCtrFecBaja2"), HtmlGenericControl)
            Dim lblCtrFecColabDesde As HtmlGenericControl = CType(Me.FindControl("lblCtrFecColabDesde"), HtmlGenericControl)
            Dim lblCtrFecFirma As HtmlGenericControl = CType(Me.FindControl("lblCtrFecFirma"), HtmlGenericControl)
            Dim lblCtrFecPoderDirectivo1 As HtmlGenericControl = CType(Me.FindControl("lblCtrFecPoderDirectivo1"), HtmlGenericControl)
            Dim lblCtrFecPoderDirectivo2 As HtmlGenericControl = CType(Me.FindControl("lblCtrFecPoderDirectivo2"), HtmlGenericControl)
            Dim lblCtrFirmaCliente As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaCliente"), HtmlGenericControl)
            Dim lblCtrFirmaClienteNotario1 As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaClienteNotario1"), HtmlGenericControl)
            Dim lblCtrFirmaClienteNotario2 As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaClienteNotario2"), HtmlGenericControl)
            Dim lblCtrFirmaClienteRepresentante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaClienteRepresentante1"), HtmlGenericControl)
            Dim lblCtrFirmaClienteRepresentante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaClienteRepresentante2"), HtmlGenericControl)
            Dim lblCtrFirmaSPFM As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaSPFM"), HtmlGenericControl)
            Dim lblCtrFirmaSPFMDirectivo1 As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaSPFMDirectivo1"), HtmlGenericControl)
            Dim lblCtrFirmaSPFMDirectivo2 As HtmlGenericControl = CType(Me.FindControl("lblCtrFirmaSPFMDirectivo2"), HtmlGenericControl)
            Dim lblCtrIdentificadorRepresentante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrIdentificadorRepresentante1"), HtmlGenericControl)
            Dim lblCtrIdentificadorRepresentante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrIdentificadorRepresentante2"), HtmlGenericControl)
            Dim lblCtrNombreNotario1 As HtmlGenericControl = CType(Me.FindControl("lblCtrNombreNotario1"), HtmlGenericControl)
            Dim lblCtrNombreNotario2 As HtmlGenericControl = CType(Me.FindControl("lblCtrNombreNotario2"), HtmlGenericControl)
            Dim lblCtrNombreRepresentante1 As HtmlGenericControl = CType(Me.FindControl("lblCtrNombreRepresentante1"), HtmlGenericControl)
            Dim lblCtrNombreRepresentante2 As HtmlGenericControl = CType(Me.FindControl("lblCtrNombreRepresentante2"), HtmlGenericControl)
            Dim lblCtrObservBaja As HtmlGenericControl = CType(Me.FindControl("lblCtrObservBaja"), HtmlGenericControl)
            Dim lblCtrObservBaja2 As HtmlGenericControl = CType(Me.FindControl("lblCtrObservBaja2"), HtmlGenericControl)
            Dim lblCtrPoblacionNotario1 As HtmlGenericControl = CType(Me.FindControl("lblCtrPoblacionNotario1"), HtmlGenericControl)
            Dim lblCtrPoblacionNotario2 As HtmlGenericControl = CType(Me.FindControl("lblCtrPoblacionNotario2"), HtmlGenericControl)
            Dim lblCtrPoderDirectivo1 As HtmlGenericControl = CType(Me.FindControl("lblCtrPoderDirectivo1"), HtmlGenericControl)
            Dim lblCtrPoderDirectivo2 As HtmlGenericControl = CType(Me.FindControl("lblCtrPoderDirectivo2"), HtmlGenericControl)
            Dim lblCtrPorcentajeColab As HtmlGenericControl = CType(Me.FindControl("lblCtrPorcentajeColab"), HtmlGenericControl)
            Dim lblCtrProtocoloNotario1 As HtmlGenericControl = CType(Me.FindControl("lblCtrProtocoloNotario1"), HtmlGenericControl)
            Dim lblCtrProtocoloNotario2 As HtmlGenericControl = CType(Me.FindControl("lblCtrProtocoloNotario2"), HtmlGenericControl)
            Dim lblCtrRespRenovacion As HtmlGenericControl = CType(Me.FindControl("lblCtrRespRenovacion"), HtmlGenericControl)
            Dim lblCtrTrimestreColab As HtmlGenericControl = CType(Me.FindControl("lblCtrTrimestreColab"), HtmlGenericControl)
            Dim lblCtrtSAP As HtmlGenericControl = CType(Me.FindControl("lblCtrtSAP"), HtmlGenericControl)
            Dim lblDc As HtmlGenericControl = CType(Me.FindControl("lblDc"), HtmlGenericControl)
            Dim lblDescMed As HtmlGenericControl = CType(Me.FindControl("lblDescMed"), HtmlGenericControl)
            Dim lblDescMed As HtmlGenericControl = CType(Me.FindControl("lblDescMed"), HtmlGenericControl)
            Dim lblDescRecoAlta As HtmlGenericControl = CType(Me.FindControl("lblDescRecoAlta"), HtmlGenericControl)
            Dim lblDescRecoBaja As HtmlGenericControl = CType(Me.FindControl("lblDescRecoBaja"), HtmlGenericControl)
            Dim lblDescTec As HtmlGenericControl = CType(Me.FindControl("lblDescTec"), HtmlGenericControl)
            Dim lblDescTec As HtmlGenericControl = CType(Me.FindControl("lblDescTec"), HtmlGenericControl)
            Dim lblDescTecHoras As HtmlGenericControl = CType(Me.FindControl("lblDescTecHoras"), HtmlGenericControl)
            Dim lblDescTecHoras As HtmlGenericControl = CType(Me.FindControl("lblDescTecHoras"), HtmlGenericControl)
            Dim lblDesde1 As HtmlGenericControl = CType(Me.FindControl("lblDesde1"), HtmlGenericControl)
            Dim lblDesde2 As HtmlGenericControl = CType(Me.FindControl("lblDesde2"), HtmlGenericControl)
            Dim lblDesde3 As HtmlGenericControl = CType(Me.FindControl("lblDesde3"), HtmlGenericControl)
            Dim lblDesde4 As HtmlGenericControl = CType(Me.FindControl("lblDesde4"), HtmlGenericControl)
            Dim lbldiapago As HtmlGenericControl = CType(Me.FindControl("lbldiapago"), HtmlGenericControl)
            Dim lblDomicilioFacturacionFilial As HtmlGenericControl = CType(Me.FindControl("lblDomicilioFacturacionFilial"), HtmlGenericControl)
            Dim lbleliminarIPC As HtmlGenericControl = CType(Me.FindControl("lbleliminarIPC"), HtmlGenericControl)
            Dim lbleliminarIPC2 As HtmlGenericControl = CType(Me.FindControl("lbleliminarIPC2"), HtmlGenericControl)
            Dim lblEmail As HtmlGenericControl = CType(Me.FindControl("lblEmail"), HtmlGenericControl)
            Dim lblEmailEnvFact As HtmlGenericControl = CType(Me.FindControl("lblEmailEnvFact"), HtmlGenericControl)
            Dim lblEmailEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblEmailEnvFactP"), HtmlGenericControl)
            Dim lblEmailFilial As HtmlGenericControl = CType(Me.FindControl("lblEmailFilial"), HtmlGenericControl)
            Dim lblEscalera As HtmlGenericControl = CType(Me.FindControl("lblEscalera"), HtmlGenericControl)
            Dim lblEscaleraDS As HtmlGenericControl = CType(Me.FindControl("lblEscaleraDS"), HtmlGenericControl)
            Dim lblEscaleraEnvFact As HtmlGenericControl = CType(Me.FindControl("lblEscaleraEnvFact"), HtmlGenericControl)
            Dim lblEscaleraEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblEscaleraEnvFactP"), HtmlGenericControl)
            Dim lblfact As HtmlGenericControl = CType(Me.FindControl("lblfact"), HtmlGenericControl)
            Dim lblFecAnexoRenovacion As HtmlGenericControl = CType(Me.FindControl("lblFecAnexoRenovacion"), HtmlGenericControl)
            Dim lblFecFin As HtmlGenericControl = CType(Me.FindControl("lblFecFin"), HtmlGenericControl)
            Dim lblFecPoderNotario1 As HtmlGenericControl = CType(Me.FindControl("lblFecPoderNotario1"), HtmlGenericControl)
            Dim lblFecPoderNotario2 As HtmlGenericControl = CType(Me.FindControl("lblFecPoderNotario2"), HtmlGenericControl)
            Dim lblFecUltReno As HtmlGenericControl = CType(Me.FindControl("lblFecUltReno"), HtmlGenericControl)
            Dim lblFieldSetFactRecos As HtmlGenericControl = CType(Me.FindControl("lblFieldSetFactRecos"), HtmlGenericControl)
            Dim lblfiltro2 As HtmlGenericControl = CType(Me.FindControl("lblfiltro2"), HtmlGenericControl)
            Dim lblfiltro3 As HtmlGenericControl = CType(Me.FindControl("lblfiltro3"), HtmlGenericControl)
            Dim lblfiltro4 As HtmlGenericControl = CType(Me.FindControl("lblfiltro4"), HtmlGenericControl)
            Dim lblfiltrosCT As HtmlGenericControl = CType(Me.FindControl("lblfiltrosCT"), HtmlGenericControl)
            Dim lblfltroCT As HtmlGenericControl = CType(Me.FindControl("lblfltroCT"), HtmlGenericControl)
            Dim lblFormaPago As HtmlGenericControl = CType(Me.FindControl("lblFormaPago"), HtmlGenericControl)
            Dim lblFsAnalCompuesta As HtmlGenericControl = CType(Me.FindControl("lblFsAnalCompuesta"), HtmlGenericControl)
            Dim lblFsAnalPerfil As HtmlGenericControl = CType(Me.FindControl("lblFsAnalPerfil"), HtmlGenericControl)
            Dim lblFsAnalSimple As HtmlGenericControl = CType(Me.FindControl("lblFsAnalSimple"), HtmlGenericControl)
            Dim lblGenerarCargoCuenta As HtmlGenericControl = CType(Me.FindControl("lblGenerarCargoCuenta"), HtmlGenericControl)
            Dim lblGenerarDocumentacion As HtmlGenericControl = CType(Me.FindControl("lblGenerarDocumentacion"), HtmlGenericControl)
            Dim lblgrabarcentro As HtmlGenericControl = CType(Me.FindControl("lblgrabarcentro"), HtmlGenericControl)
            Dim lblHDAnx As HtmlGenericControl = CType(Me.FindControl("lblHDAnx"), HtmlGenericControl)
            Dim lblHDCtrt As HtmlGenericControl = CType(Me.FindControl("lblHDCtrt"), HtmlGenericControl)
            Dim lblHistColab As HtmlGenericControl = CType(Me.FindControl("lblHistColab"), HtmlGenericControl)
            Dim lblhistTarifa As HtmlGenericControl = CType(Me.FindControl("lblhistTarifa"), HtmlGenericControl)
            Dim lblHorasProducto As HtmlGenericControl = CType(Me.FindControl("lblHorasProducto"), HtmlGenericControl)
            Dim lblHorasProductoAutonomo As HtmlGenericControl = CType(Me.FindControl("lblHorasProductoAutonomo"), HtmlGenericControl)
            Dim lblHorasProductoBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblHorasProductoBolsaHoras"), HtmlGenericControl)
            Dim lblIban As HtmlGenericControl = CType(Me.FindControl("lblIban"), HtmlGenericControl)
            Dim lblIdentificador As HtmlGenericControl = CType(Me.FindControl("lblIdentificador"), HtmlGenericControl)
            Dim lblImpAnexo As HtmlGenericControl = CType(Me.FindControl("lblImpAnexo"), HtmlGenericControl)
            Dim lblImpContrato As HtmlGenericControl = CType(Me.FindControl("lblImpContrato"), HtmlGenericControl)
            Dim lblImporteARTarifa As HtmlGenericControl = CType(Me.FindControl("lblImporteARTarifa"), HtmlGenericControl)
            Dim lblImporteBRTarifa As HtmlGenericControl = CType(Me.FindControl("lblImporteBRTarifa"), HtmlGenericControl)
            Dim lblimporteqshd As HtmlGenericControl = CType(Me.FindControl("lblimporteqshd"), HtmlGenericControl)
            Dim lblImporteTarifa As HtmlGenericControl = CType(Me.FindControl("lblImporteTarifa"), HtmlGenericControl)
            Dim lblImporteTarifa As HtmlGenericControl = CType(Me.FindControl("lblImporteTarifa"), HtmlGenericControl)
            Dim lblImporteTarifaDescuento As HtmlGenericControl = CType(Me.FindControl("lblImporteTarifaDescuento"), HtmlGenericControl)
            Dim lblImporteTarifaDescuento As HtmlGenericControl = CType(Me.FindControl("lblImporteTarifaDescuento"), HtmlGenericControl)
            Dim lblImporteTarifaReco As HtmlGenericControl = CType(Me.FindControl("lblImporteTarifaReco"), HtmlGenericControl)
            Dim lblImporteTarifaRecoDescuento As HtmlGenericControl = CType(Me.FindControl("lblImporteTarifaRecoDescuento"), HtmlGenericControl)
            Dim lblImpPruebasVSI As HtmlGenericControl = CType(Me.FindControl("lblImpPruebasVSI"), HtmlGenericControl)
            Dim lblImpRPF As HtmlGenericControl = CType(Me.FindControl("lblImpRPF"), HtmlGenericControl)
            Dim lblImpUndIncl As HtmlGenericControl = CType(Me.FindControl("lblImpUndIncl"), HtmlGenericControl)
            Dim lblIncluyeRecos As HtmlGenericControl = CType(Me.FindControl("lblIncluyeRecos"), HtmlGenericControl)
            Dim lblLegendAnexo As HtmlGenericControl = CType(Me.FindControl("lblLegendAnexo"), HtmlGenericControl)
            Dim lblLegendCentrosTotal As HtmlGenericControl = CType(Me.FindControl("lblLegendCentrosTotal"), HtmlGenericControl)
            Dim lblLegendCentrosTrabajo As HtmlGenericControl = CType(Me.FindControl("lblLegendCentrosTrabajo"), HtmlGenericControl)
            Dim lblLegendCtrBaja As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrBaja"), HtmlGenericControl)
            Dim lblLegendCtrBaja2 As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrBaja2"), HtmlGenericControl)
            Dim lblLegendCtrColaborador As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrColaborador"), HtmlGenericControl)
            Dim lblLegendCtrContactos As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrContactos"), HtmlGenericControl)
            Dim lblLegendCtrDirEnvFact As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrDirEnvFact"), HtmlGenericControl)
            Dim lblLegendCtrDomiBanc As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrDomiBanc"), HtmlGenericControl)
            Dim lblLegendCtrFirma As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrFirma"), HtmlGenericControl)
            Dim lblLegendCtrIndicadores As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrIndicadores"), HtmlGenericControl)
            Dim lblLegendCtrRenoPrecios As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrRenoPrecios"), HtmlGenericControl)
            Dim lblLegendCtrRespCap As HtmlGenericControl = CType(Me.FindControl("lblLegendCtrRespCap"), HtmlGenericControl)
            Dim lblLegendFacturacion As HtmlGenericControl = CType(Me.FindControl("lblLegendFacturacion"), HtmlGenericControl)
            Dim lblLegendGrupoOtrasActividades As HtmlGenericControl = CType(Me.FindControl("lblLegendGrupoOtrasActividades"), HtmlGenericControl)
            Dim lblLegendHistColab As HtmlGenericControl = CType(Me.FindControl("lblLegendHistColab"), HtmlGenericControl)
            Dim lblLegendHistDocumento As HtmlGenericControl = CType(Me.FindControl("lblLegendHistDocumento"), HtmlGenericControl)
            Dim lblLegendHistTarifa As HtmlGenericControl = CType(Me.FindControl("lblLegendHistTarifa"), HtmlGenericControl)
            Dim lblLegendTarificacionAutonomos As HtmlGenericControl = CType(Me.FindControl("lblLegendTarificacionAutonomos"), HtmlGenericControl)
            Dim lblLegendTarificacionBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblLegendTarificacionBolsaHoras"), HtmlGenericControl)
            Dim lblLegendTarificacionModalidades As HtmlGenericControl = CType(Me.FindControl("lblLegendTarificacionModalidades"), HtmlGenericControl)
            Dim lblLegendTarificacionProductos As HtmlGenericControl = CType(Me.FindControl("lblLegendTarificacionProductos"), HtmlGenericControl)
            Dim lblLegendTrabTotal As HtmlGenericControl = CType(Me.FindControl("lblLegendTrabTotal"), HtmlGenericControl)
            Dim lbllimpiarfiltroct As HtmlGenericControl = CType(Me.FindControl("lbllimpiarfiltroct"), HtmlGenericControl)
            Dim lbllineaproducto As HtmlGenericControl = CType(Me.FindControl("lbllineaproducto"), HtmlGenericControl)
            Dim lblModalidades As HtmlGenericControl = CType(Me.FindControl("lblModalidades"), HtmlGenericControl)
            Dim lblModEPAnx As HtmlGenericControl = CType(Me.FindControl("lblModEPAnx"), HtmlGenericControl)
            Dim lblModHIAnx As HtmlGenericControl = CType(Me.FindControl("lblModHIAnx"), HtmlGenericControl)
            Dim lblModHorMed As HtmlGenericControl = CType(Me.FindControl("lblModHorMed"), HtmlGenericControl)
            Dim lblModHorMed As HtmlGenericControl = CType(Me.FindControl("lblModHorMed"), HtmlGenericControl)
            Dim lblModHorTec As HtmlGenericControl = CType(Me.FindControl("lblModHorTec"), HtmlGenericControl)
            Dim lblModHorTec As HtmlGenericControl = CType(Me.FindControl("lblModHorTec"), HtmlGenericControl)
            Dim lblModMTAnx As HtmlGenericControl = CType(Me.FindControl("lblModMTAnx"), HtmlGenericControl)
            Dim lblModRPFAnexo As HtmlGenericControl = CType(Me.FindControl("lblModRPFAnexo"), HtmlGenericControl)
            Dim lblModRPFCtrt As HtmlGenericControl = CType(Me.FindControl("lblModRPFCtrt"), HtmlGenericControl)
            Dim lblModSheAnx As HtmlGenericControl = CType(Me.FindControl("lblModSheAnx"), HtmlGenericControl)
            Dim lblModSheCtrt As HtmlGenericControl = CType(Me.FindControl("lblModSheCtrt"), HtmlGenericControl)
            Dim lblModSTAnx As HtmlGenericControl = CType(Me.FindControl("lblModSTAnx"), HtmlGenericControl)
            Dim lblModTot As HtmlGenericControl = CType(Me.FindControl("lblModTot"), HtmlGenericControl)
            Dim lblModTot As HtmlGenericControl = CType(Me.FindControl("lblModTot"), HtmlGenericControl)
            Dim lblModTOTALAnx As HtmlGenericControl = CType(Me.FindControl("lblModTOTALAnx"), HtmlGenericControl)
            Dim lblModTotCtrt As HtmlGenericControl = CType(Me.FindControl("lblModTotCtrt"), HtmlGenericControl)
            Dim lblMotivoDescuento As HtmlGenericControl = CType(Me.FindControl("lblMotivoDescuento"), HtmlGenericControl)
            Dim lblMotivoDescuento As HtmlGenericControl = CType(Me.FindControl("lblMotivoDescuento"), HtmlGenericControl)
            Dim lblNIncluidos As HtmlGenericControl = CType(Me.FindControl("lblNIncluidos"), HtmlGenericControl)
            Dim lblNomBanco As HtmlGenericControl = CType(Me.FindControl("lblNomBanco"), HtmlGenericControl)
            Dim lblNombre As HtmlGenericControl = CType(Me.FindControl("lblNombre"), HtmlGenericControl)
            Dim lblNombreCompleto As HtmlGenericControl = CType(Me.FindControl("lblNombreCompleto"), HtmlGenericControl)
            Dim lblNumCuenta As HtmlGenericControl = CType(Me.FindControl("lblNumCuenta"), HtmlGenericControl)
            Dim lblNumero As HtmlGenericControl = CType(Me.FindControl("lblNumero"), HtmlGenericControl)
            Dim lblNumeroDS As HtmlGenericControl = CType(Me.FindControl("lblNumeroDS"), HtmlGenericControl)
            Dim lblNumeroEnvFact As HtmlGenericControl = CType(Me.FindControl("lblNumeroEnvFact"), HtmlGenericControl)
            Dim lblNumeroEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblNumeroEnvFactP"), HtmlGenericControl)
            Dim lblNumFaxCentro As HtmlGenericControl = CType(Me.FindControl("lblNumFaxCentro"), HtmlGenericControl)
            Dim lblNumFaxDS As HtmlGenericControl = CType(Me.FindControl("lblNumFaxDS"), HtmlGenericControl)
            Dim lblNumFaxEnvFact As HtmlGenericControl = CType(Me.FindControl("lblNumFaxEnvFact"), HtmlGenericControl)
            Dim lblNumFaxEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblNumFaxEnvFactP"), HtmlGenericControl)
            Dim lblNumpedidoF As HtmlGenericControl = CType(Me.FindControl("lblNumpedidoF"), HtmlGenericControl)
            Dim lblNumpedidoF As HtmlGenericControl = CType(Me.FindControl("lblNumpedidoF"), HtmlGenericControl)
            Dim lblNumpedidoV As HtmlGenericControl = CType(Me.FindControl("lblNumpedidoV"), HtmlGenericControl)
            Dim lblNumpedidoV As HtmlGenericControl = CType(Me.FindControl("lblNumpedidoV"), HtmlGenericControl)
            Dim lblNumTelf As HtmlGenericControl = CType(Me.FindControl("lblNumTelf"), HtmlGenericControl)
            Dim lblNumTelfDS As HtmlGenericControl = CType(Me.FindControl("lblNumTelfDS"), HtmlGenericControl)
            Dim lblNumTelfEnvFact As HtmlGenericControl = CType(Me.FindControl("lblNumTelfEnvFact"), HtmlGenericControl)
            Dim lblNumTelfEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblNumTelfEnvFactP"), HtmlGenericControl)
            Dim lblOficinaContable As HtmlGenericControl = CType(Me.FindControl("lblOficinaContable"), HtmlGenericControl)
            Dim lblOrganoGestor As HtmlGenericControl = CType(Me.FindControl("lblOrganoGestor"), HtmlGenericControl)
            Dim lblOrganoProponente As HtmlGenericControl = CType(Me.FindControl("lblOrganoProponente"), HtmlGenericControl)
            Dim lblOtrasPruebasExternas As HtmlGenericControl = CType(Me.FindControl("lblOtrasPruebasExternas"), HtmlGenericControl)
            Dim lblPeriPago As HtmlGenericControl = CType(Me.FindControl("lblPeriPago"), HtmlGenericControl)
            Dim lblPersonaFilial As HtmlGenericControl = CType(Me.FindControl("lblPersonaFilial"), HtmlGenericControl)
            Dim lblPiso As HtmlGenericControl = CType(Me.FindControl("lblPiso"), HtmlGenericControl)
            Dim lblPisoDS As HtmlGenericControl = CType(Me.FindControl("lblPisoDS"), HtmlGenericControl)
            Dim lblPisoEnvFact As HtmlGenericControl = CType(Me.FindControl("lblPisoEnvFact"), HtmlGenericControl)
            Dim lblPisoEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblPisoEnvFactP"), HtmlGenericControl)
            Dim lblPlazoPago As HtmlGenericControl = CType(Me.FindControl("lblPlazoPago"), HtmlGenericControl)
            Dim lblPoblacion As HtmlGenericControl = CType(Me.FindControl("lblPoblacion"), HtmlGenericControl)
            Dim lblPoblacionDS As HtmlGenericControl = CType(Me.FindControl("lblPoblacionDS"), HtmlGenericControl)
            Dim lblPoblacionEnvFact As HtmlGenericControl = CType(Me.FindControl("lblPoblacionEnvFact"), HtmlGenericControl)
            Dim lblPoblacionEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblPoblacionEnvFactP"), HtmlGenericControl)
            Dim lblPoblacionFilial As HtmlGenericControl = CType(Me.FindControl("lblPoblacionFilial"), HtmlGenericControl)
            Dim lblPortal As HtmlGenericControl = CType(Me.FindControl("lblPortal"), HtmlGenericControl)
            Dim lblPortalDS As HtmlGenericControl = CType(Me.FindControl("lblPortalDS"), HtmlGenericControl)
            Dim lblPortalEnvFact As HtmlGenericControl = CType(Me.FindControl("lblPortalEnvFact"), HtmlGenericControl)
            Dim lblPortalEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblPortalEnvFactP"), HtmlGenericControl)
            Dim lblPrecio1 As HtmlGenericControl = CType(Me.FindControl("lblPrecio1"), HtmlGenericControl)
            Dim lblPrecio2 As HtmlGenericControl = CType(Me.FindControl("lblPrecio2"), HtmlGenericControl)
            Dim lblPrecio3 As HtmlGenericControl = CType(Me.FindControl("lblPrecio3"), HtmlGenericControl)
            Dim lblPrecio4 As HtmlGenericControl = CType(Me.FindControl("lblPrecio4"), HtmlGenericControl)
            Dim lblPrecioMedicoProducto As HtmlGenericControl = CType(Me.FindControl("lblPrecioMedicoProducto"), HtmlGenericControl)
            Dim lblPrecioMedicoProductoAutonomo As HtmlGenericControl = CType(Me.FindControl("lblPrecioMedicoProductoAutonomo"), HtmlGenericControl)
            Dim lblPrecioMedicoProductoBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblPrecioMedicoProductoBolsaHoras"), HtmlGenericControl)
            Dim lblPrecioProducto As HtmlGenericControl = CType(Me.FindControl("lblPrecioProducto"), HtmlGenericControl)
            Dim lblPrecioProductoAutonomo As HtmlGenericControl = CType(Me.FindControl("lblPrecioProductoAutonomo"), HtmlGenericControl)
            Dim lblPrecioProductoBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblPrecioProductoBolsaHoras"), HtmlGenericControl)
            Dim lblPrecioTecnicoProducto As HtmlGenericControl = CType(Me.FindControl("lblPrecioTecnicoProducto"), HtmlGenericControl)
            Dim lblPrecioTecnicoProductoAutonomo As HtmlGenericControl = CType(Me.FindControl("lblPrecioTecnicoProductoAutonomo"), HtmlGenericControl)
            Dim lblPrecioTecnicoProductoBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblPrecioTecnicoProductoBolsaHoras"), HtmlGenericControl)
            Dim lblPrecioTotalProducto As HtmlGenericControl = CType(Me.FindControl("lblPrecioTotalProducto"), HtmlGenericControl)
            Dim lblPrecioTotalProductoAutonomo As HtmlGenericControl = CType(Me.FindControl("lblPrecioTotalProductoAutonomo"), HtmlGenericControl)
            Dim lblPrecioTotalProductoBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblPrecioTotalProductoBolsaHoras"), HtmlGenericControl)
            Dim lblProvincia As HtmlGenericControl = CType(Me.FindControl("lblProvincia"), HtmlGenericControl)
            Dim lblProvinciaDS As HtmlGenericControl = CType(Me.FindControl("lblProvinciaDS"), HtmlGenericControl)
            Dim lblProvinciaEnvFact As HtmlGenericControl = CType(Me.FindControl("lblProvinciaEnvFact"), HtmlGenericControl)
            Dim lblProvinciaEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblProvinciaEnvFactP"), HtmlGenericControl)
            Dim lblProvinciaFilial As HtmlGenericControl = CType(Me.FindControl("lblProvinciaFilial"), HtmlGenericControl)
            Dim lblProvinciaNotario1 As HtmlGenericControl = CType(Me.FindControl("lblProvinciaNotario1"), HtmlGenericControl)
            Dim lblProvinciaNotario2 As HtmlGenericControl = CType(Me.FindControl("lblProvinciaNotario2"), HtmlGenericControl)
            Dim lblPuerta As HtmlGenericControl = CType(Me.FindControl("lblPuerta"), HtmlGenericControl)
            Dim lblPuertaDS As HtmlGenericControl = CType(Me.FindControl("lblPuertaDS"), HtmlGenericControl)
            Dim lblPuertaEnvFact As HtmlGenericControl = CType(Me.FindControl("lblPuertaEnvFact"), HtmlGenericControl)
            Dim lblPuertaEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblPuertaEnvFactP"), HtmlGenericControl)
            Dim lblRAPAnexo As HtmlGenericControl = CType(Me.FindControl("lblRAPAnexo"), HtmlGenericControl)
            Dim lblRAPCtrt As HtmlGenericControl = CType(Me.FindControl("lblRAPCtrt"), HtmlGenericControl)
            Dim lblRazonSocialAnexoRenovacion As HtmlGenericControl = CType(Me.FindControl("lblRazonSocialAnexoRenovacion"), HtmlGenericControl)
            Dim lblRBPAnexo As HtmlGenericControl = CType(Me.FindControl("lblRBPAnexo"), HtmlGenericControl)
            Dim lblRBPCtrt As HtmlGenericControl = CType(Me.FindControl("lblRBPCtrt"), HtmlGenericControl)
            Dim lblReconocimientosPrefacturados As HtmlGenericControl = CType(Me.FindControl("lblReconocimientosPrefacturados"), HtmlGenericControl)
            Dim lblRecosVSI As HtmlGenericControl = CType(Me.FindControl("lblRecosVSI"), HtmlGenericControl)
            Dim lblReferenciaDomi As HtmlGenericControl = CType(Me.FindControl("lblReferenciaDomi"), HtmlGenericControl)
            Dim lblRefFact As HtmlGenericControl = CType(Me.FindControl("lblRefFact"), HtmlGenericControl)
            Dim lblRPFAnexo As HtmlGenericControl = CType(Me.FindControl("lblRPFAnexo"), HtmlGenericControl)
            Dim lblRPFCtrato As HtmlGenericControl = CType(Me.FindControl("lblRPFCtrato"), HtmlGenericControl)
            Dim lblRPFIncluidosAnexo As HtmlGenericControl = CType(Me.FindControl("lblRPFIncluidosAnexo"), HtmlGenericControl)
            Dim lblRPFIncluidosCtrt As HtmlGenericControl = CType(Me.FindControl("lblRPFIncluidosCtrt"), HtmlGenericControl)
            Dim lblTarifa As HtmlGenericControl = CType(Me.FindControl("lblTarifa"), HtmlGenericControl)
            Dim lblTelefonoFilial As HtmlGenericControl = CType(Me.FindControl("lblTelefonoFilial"), HtmlGenericControl)
            Dim lblTerminadoToVigente As HtmlGenericControl = CType(Me.FindControl("lblTerminadoToVigente"), HtmlGenericControl)
            Dim lblTipDocu As HtmlGenericControl = CType(Me.FindControl("lblTipDocu"), HtmlGenericControl)
            Dim lblTipoAnaliticaCompuesta As HtmlGenericControl = CType(Me.FindControl("lblTipoAnaliticaCompuesta"), HtmlGenericControl)
            Dim lblTipoAnaliticaPerfil As HtmlGenericControl = CType(Me.FindControl("lblTipoAnaliticaPerfil"), HtmlGenericControl)
            Dim lblTipoAnaliticaSimple As HtmlGenericControl = CType(Me.FindControl("lblTipoAnaliticaSimple"), HtmlGenericControl)
            Dim lblTrabAnexo As HtmlGenericControl = CType(Me.FindControl("lblTrabAnexo"), HtmlGenericControl)
            Dim lblTrabConstruccion As HtmlGenericControl = CType(Me.FindControl("lblTrabConstruccion"), HtmlGenericControl)
            Dim lblTrabIndustria As HtmlGenericControl = CType(Me.FindControl("lblTrabIndustria"), HtmlGenericControl)
            Dim lblTrabOficina As HtmlGenericControl = CType(Me.FindControl("lblTrabOficina"), HtmlGenericControl)
            Dim lblTrabTotal As HtmlGenericControl = CType(Me.FindControl("lblTrabTotal"), HtmlGenericControl)
            Dim lblTramos As HtmlGenericControl = CType(Me.FindControl("lblTramos"), HtmlGenericControl)
            Dim lblUnidadTramitadora As HtmlGenericControl = CType(Me.FindControl("lblUnidadTramitadora"), HtmlGenericControl)
            Dim lblVacio As HtmlGenericControl = CType(Me.FindControl("lblVacio"), HtmlGenericControl)
            Dim lblVacioAutonomo As HtmlGenericControl = CType(Me.FindControl("lblVacioAutonomo"), HtmlGenericControl)
            Dim lblVacioBolsaHoras As HtmlGenericControl = CType(Me.FindControl("lblVacioBolsaHoras"), HtmlGenericControl)
            Dim lblVia As HtmlGenericControl = CType(Me.FindControl("lblVia"), HtmlGenericControl)
            Dim lblViaDS As HtmlGenericControl = CType(Me.FindControl("lblViaDS"), HtmlGenericControl)
            Dim lblViaEnvFact As HtmlGenericControl = CType(Me.FindControl("lblViaEnvFact"), HtmlGenericControl)
            Dim lblViaEnvFactP As HtmlGenericControl = CType(Me.FindControl("lblViaEnvFactP"), HtmlGenericControl)
            Dim RFNLabel1 As HtmlGenericControl = CType(Me.FindControl("RFNLabel1"), HtmlGenericControl)
            Dim RFNLabel10 As HtmlGenericControl = CType(Me.FindControl("RFNLabel10"), HtmlGenericControl)
            Dim RFNLabel2 As HtmlGenericControl = CType(Me.FindControl("RFNLabel2"), HtmlGenericControl)
            Dim RFNLabel5 As HtmlGenericControl = CType(Me.FindControl("RFNLabel5"), HtmlGenericControl)
            Dim RFNLabel6 As HtmlGenericControl = CType(Me.FindControl("RFNLabel6"), HtmlGenericControl)
            Dim RFNLabel9 As HtmlGenericControl = CType(Me.FindControl("RFNLabel9"), HtmlGenericControl)



            lblLegendCtrContrato.InnerText = EN.lblLegendCtrContrato
            lblCtrCodContrato.InnerText = EN.lblCtrCodContrato
            lblCodContratoAsociado.InnerText = EN.lblCodContratoAsociado
            lblContratoSAP.InnerText = EN.lblContratoSAP
            lblCtrEstadoContrato.InnerText = EN.lblCtrEstadoContrato
            lblCtrFecTerminado.InnerText = EN.lblCtrFecTerminado
            lblCtrFecEstadoContrato.InnerText = EN.lblCtrFecEstadoContrato
            lblCtrFecFirma1.InnerText = EN.lblCtrFecFirma1
            lblEstadoPresupuesto.InnerText = EN.lblEstadoPresupuesto
            lblCtrFecEstadoPresupuesto.InnerText = EN.lblCtrFecEstadoPresupuesto
            lblImporteTotalContrato.InnerText = EN.lblImporteTotalContrato
            lblTipoContrato.InnerText = EN.lblTipoContrato
            lblidioma.InnerText = EN.lblidioma
            lblEstadoDocumento.InnerText = EN.lblEstadoDocumento
            lblCtrFecGeneracion.InnerText = EN.lblCtrFecGeneracion
            lblCtrVersionDocumento.InnerText = EN.lblCtrVersionDocumento
            lblCtrCodPresupuesto.InnerText = EN.lblCtrCodPresupuesto

            lblRazonSocial1.InnerText = EN.lblRazonSocial1
            lblCentGest.InnerText = EN.lblCentGest
            lblPersonaAlta.InnerText = EN.lblPersonaAlta
            lblObservaciones.InnerText = EN.lblObservaciones
            lblObservacionesTec.InnerText = EN.lblObservacionesTec
            lblObservacionesMed.InnerText = EN.lblObservacionesMed
            lblHorasPerfilesMedycsa.InnerText = EN.lblHorasPerfilesMedycsa
            lblAltaGrupoCliente.InnerText = EN.lblAltaGrupoCliente
            lblCeco.InnerText = EN.lblCeco
            lblLineaNegocio.InnerText = EN.lblLineaNegocio
            lblGestor.InnerText = EN.lblGestor
            lblDesdeContrato.InnerText = EN.lblDesdeContrato
            lblListadoContratos.InnerText = EN.lblListadoContratos
            'lblLegendDesdeContrato.InnerText = EN.lblLegendDesdeContrato
            lblMigrarContactos.InnerText = EN.lblMigrarContactos
            lblMigrarFirmantesCliente.InnerText = EN.lblMigrarFirmantesCliente
            lblMigrarFirmantesSPFM.InnerText = EN.lblMigrarFirmantesSPFM
            lblLegendDatosCliente.InnerText = EN.lblLegendDatosCliente
            lblRazonSocial.InnerText = EN.lblRazonSocial
            lblActividad.InnerText = EN.lblActividad
            lblDomicilioSocial.InnerText = EN.lblDomicilioSocial
            lblGrabarDomiSocial.InnerText = EN.lblGrabarDomiSocial
            lblAltaNombreCompletoSocial.InnerText = EN.lblAltaNombreCompletoSocial
            lblAltaNombreSocial.InnerText = EN.lblAltaNombreSocial
            lblAltaApellido1Social.InnerText = EN.lblAltaApellido1Social
            lblAltaApellido2Social.InnerText = EN.lblAltaApellido2Social

            Dim up As UpdatePanel = CType(Me.FindControl("UpdatePanel1"), UpdatePanel)
            If up IsNot Nothing Then
                up.Update()
            End If
        Catch ex As Exception
            MostrarMensaje(ex.Message)
        End Try
    End Sub

    Private Sub GuardarContratoSap()

        Dim esContratoMedycsaMigrado As Boolean = False
        If (txtContratoSAP.Text.Substring(0, 4) = "7004") Then
            esContratoMedycsaMigrado = True
        End If
        Dim resultado As Boolean = False

        If Not esContratoMedycsaMigrado AndAlso ddlCtrEstadoContrato.SelectedValue = "T" AndAlso Not Rfnchkmigrado.Checked Then
            Me.MostrarMensaje("Este contrato solo puede ser terminado desde SAP", TEXTO_INFORMACION)

        Else

            If (ddlCtrEstadoContrato.SelectedValue = "T" AndAlso txtCtrContratoNuevo.Text.Trim() <> "" AndAlso Rfnchkmigrado.Checked AndAlso Not ValidaCodContratoVigente()) Then
                Return
            End If

            If Not ValidarActividadesEspecificasSinFirmantes() Then
                Return
            End If

            resultado = GuardaContrato()

            If resultado AndAlso mensajeGuardar Then
                Dim mensaje As String
                If hfface.Value = 1 Then
                    mensaje = "Se ha grabado el Contrato correctamente. Pero no ha grabado los datos FACE o son incorrectos, al ser un organismo público debe rellenarlos correctamente. No podrá poner el contrato VIGENTE hasta que los datos de FACE sean correctos."
                Else
                    mensaje = "Se ha grabado el Contrato correctamente."
                End If
                Me.MostrarMensaje(mensaje, TEXTO_INFORMACION)

                Dim estAnt As String = ddlCtrEstadoContratoOculto.SelectedValue
                Dim estNue As String = ddlCtrEstadoContrato.SelectedValue

                ddlCtrEstadoContratoOculto.SelectedValue = ddlCtrEstadoContrato.SelectedValue
                Me.AddLoadScript("ForzaCambio();")
                Me.AddLoadScript("EvaluaEstado(true);")
                Me.AddLoadScript("filtrarEstados();")

                If estAnt <> estNue Then
                    RELOAD()
                End If
            End If

        End If

    End Sub

    Private Sub GuardarContratoNoSap()
        Dim resultado As Boolean = False
        Dim estAnt As String = ddlCtrEstadoContratoOculto.SelectedValue
        Dim estNue As String = ddlCtrEstadoContrato.SelectedValue

        If (ddlCtrEstadoContrato.SelectedValue = "T" AndAlso txtCtrContratoNuevo.Text.Trim() <> "" AndAlso Not ValidaCodContratoVigente()) Then
            Return
        End If

        If Not ValidarActividadesEspecificasSinFirmantes() Then
            Return
        End If

        resultado = GuardaContrato()

        If resultado AndAlso mensajeGuardar Then
            Dim mensaje As String
            If hfface.Value = 1 Then
                If cacheContratacion.hfEsPerfilCentral.Value = "S" Then
                    mensaje = "Se ha grabado el Contrato correctamente. Pero no ha grabado los datos FACE o son erróneos, al ser una organismo público debe rellenarlos. Al ser usuario de CENTRAL puede poner el contrato VIGENTE."
                Else
                    mensaje = "Se ha grabado el Contrato correctamente. Pero no ha grabado los datos FACE al ser una organismo público debe rellenarlos. No podrá poner el contrato VIGENTE hasta que los datos de FACE sean correctos."
                End If
            Else
                mensaje = "Se ha grabado el Contrato correctamente."
            End If
            Me.AddLoadScript("Mensajes('" & mensaje & "', '" & estAnt & "', '" & estNue & "', '" & hfface.Value & "');")

            ddlCtrEstadoContratoOculto.SelectedValue = ddlCtrEstadoContrato.SelectedValue
            Me.AddLoadScript("ForzaCambio();")
            Me.AddLoadScript("EvaluaEstado(true);")
            Me.AddLoadScript("filtrarEstados();")
        End If

    End Sub

    Private Sub btnGrabarCentroDireFact_Click(sender As Object, e As System.EventArgs) Handles btnGrabarCentroDireFact.Click


        Dim wsContratacion As New WsContratacion.WsContratacion
        Dim resultado As Integer = 0

        Try

            If Not String.IsNullOrEmpty(hfIdCentroDireccion.Value) Then

                Dim dsParticularizacion As New DataSet
                Dim dtParticularizacion As New DataTable
                Dim drParticularizacion As DataRow

                dtParticularizacion.Columns.Add("ID_CLIENTE")
                dtParticularizacion.Columns.Add("COD_CENTRO")
                dtParticularizacion.Columns.Add("COD_HISTORICO")
                dtParticularizacion.Columns.Add("ID_CONTRATO")
                dtParticularizacion.Columns.Add("PARTICULARIZADO")
                dtParticularizacion.Columns.Add("ID_REGION")
                dtParticularizacion.Columns.Add("ID_POBLACION")
                dtParticularizacion.Columns.Add("COD_POSTAL")
                dtParticularizacion.Columns.Add("DES_DOMICILIO")
                dtParticularizacion.Columns.Add("NUM_TELEFONO")
                dtParticularizacion.Columns.Add("NUM_FAX")
                dtParticularizacion.Columns.Add("DES_ATENCION")
                dtParticularizacion.Columns.Add("DES_EMAIL")

                drParticularizacion = dtParticularizacion.NewRow

                drParticularizacion("ID_CLIENTE") = hfidCliente.Value
                drParticularizacion("COD_CENTRO") = hfIdCentroDireccion.Value
                drParticularizacion("COD_HISTORICO") = hfIdCentroHist.Value
                drParticularizacion("ID_CONTRATO") = txtCtrIdContrato.Text

                If rfncheckFactparti.Checked Then
                    drParticularizacion("PARTICULARIZADO") = "S"
                    drParticularizacion("ID_REGION") = cmbProvinciaEnvFactP.SelectedValue
                    drParticularizacion("ID_POBLACION") = ccdPoblacionEnvFactP.Codigo
                    drParticularizacion("COD_POSTAL") = cmbCPEnvFactP.SelectedValue

                    Dim sDesDireccionEnvFact As String = ""

                    sDesDireccionEnvFact = GenerarDireccionCentro(cmbTipoViaEnvFactP.SelectedValue, txtCalleEnvFactP.Text.Trim, txtNumEnvFactP.Text.Trim, txtPortalEnvFactP.Text.Trim, txtEscaleraEnvFactP.Text.Trim, txtPisoEnvFactP.Text.Trim, txtPuertaEnvFactP.Text.Trim)

                    drParticularizacion("DES_DOMICILIO") = sDesDireccionEnvFact
                    drParticularizacion("NUM_TELEFONO") = txtTelefonoEnvFactP.Text.Trim
                    drParticularizacion("NUM_FAX") = txtNumFaxEnvFactP.Text.Trim
                    drParticularizacion("DES_ATENCION") = txtAtencionEnvFactP.Text.Trim
                    drParticularizacion("DES_EMAIL") = txtEmailEnvFactP.Text.Trim
                Else
                    drParticularizacion("PARTICULARIZADO") = "N"
                    drParticularizacion("ID_REGION") = ""
                    drParticularizacion("ID_POBLACION") = ""
                    drParticularizacion("COD_POSTAL") = ""
                    drParticularizacion("DES_DOMICILIO") = ""
                    drParticularizacion("NUM_TELEFONO") = ""
                    drParticularizacion("NUM_FAX") = ""
                    drParticularizacion("DES_ATENCION") = ""
                    drParticularizacion("DES_EMAIL") = ""
                End If

                dtParticularizacion.Rows.Add(drParticularizacion)

                dsParticularizacion.Tables.Add(dtParticularizacion.Copy)

                resultado = wsContratacion.GuardaEnvioParticularizadoCentro(dsParticularizacion.Tables(0), Usuario.Login)

                If resultado = -1 Then
                    Me.AddLoadScript("CambioGrid(true," + hfIdCentroDireccion.Value + ");")
                    Me.MostrarMensaje("Se ha grabado la particularización de envío al Centro de Trabajo para el contrato seleccionado.", TEXTO_INFORMACION)
                End If
                If resultado > 0 Then
                    If rfncheckFactparti.Checked Then
                        Me.AddLoadScript("CambioGrid(true," + hfIdCentroDireccion.Value + ");")
                        Me.MostrarMensaje("Se ha modificado la particularización de envío al Centro de Trabajo para el contrato seleccionado.", TEXTO_INFORMACION)
                    Else
                        Me.AddLoadScript("CambioGrid(false," + hfIdCentroDireccion.Value + ");")
                        Me.MostrarMensaje("Se ha quitado la particularización de envío al Centro de Trabajo para el contrato seleccionado.", TEXTO_INFORMACION)
                    End If

                End If

            End If

        Catch ex As Exception
            Me.MostrarMensaje("Error al grabar la Particularización de envío a Centro de Trabajo." & ex.ToString, TEXTO_ERROR)

        End Try


    End Sub

    Private Sub btnGeneraDocumento_Click(sender As Object, e As System.EventArgs) Handles btnGeneraDocumento.Click
        Try

            Dim erroresTryParse As Boolean = True

            If hfGrabar.Value = 1 Then
                MostrarMensaje("Hay productos no compatibles con la linea de productos actual.", TEXTO_ERROR)
                Return
            End If

            GuardaContrato()
            If ddlCtrEstadoContratoOculto.SelectedValue = "P" OrElse ddlCtrEstadoContratoOculto.SelectedValue = "V" Then
                InfContrato()
            Else

                Dim resultado As Integer = 0
                Dim iIdContrato As Integer = 0
                erroresTryParse = Integer.TryParse(txtCtrIdContrato.Text, iIdContrato)

                InfContrato()

                If cambiaEstado Then
                    Using wsContratacion As New WsContratacion.WsContratacion
                        resultado = wsContratacion.CambioEstadoContrato(iIdContrato, "P", Usuario.Login)
                    End Using

                    cambiaEstado = False
                End If

            End If

            Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
            GetDocuments(detallesContrato)

        Catch ex As Exception
            Me.MostrarMensaje(ex.ToString, "Error al generar el documento")
        End Try
    End Sub

    Private Sub GenerarCartaBajaContrato(sender As Object, e As System.EventArgs) Handles btnGenerarCartaBaja.Click
        GestionaCartasBaja(NOMBRE_CARTA_BAJA_1 & txtCtrCodContrato.Text & ".docx", 1)
    End Sub

    Private Sub GenerarCartaBajaFueraPlazo(sender As Object, e As System.EventArgs) Handles btnGenerarCartaBaja2.Click
        GestionaCartasBaja(NOMBRE_CARTA_BAJA_2 & txtCtrCodContrato.Text & ".docx", 2)
    End Sub

    Private Sub GenerarCartaBajaPreaviso(sender As Object, e As System.EventArgs) Handles btnGenerarCartaBaja3.Click
        GestionaCartasBaja(NOMBRE_CARTA_BAJA_3 & txtCtrCodContrato.Text & ".docx", 3)
    End Sub

    Private Sub GestionaCartasBaja(nombreDocumento As String, numPlantilla As Integer)
        Try

            Using wsContratacion As New WsContratacion.WsContratacion
                Dim dsDatosDocumentoContrato As DataSet = MetodosAux.DescomprimirDataset(wsContratacion.ObtenerDatosDocumentoContrato(txtCtrIdContrato.Text, Usuario.Login))

                If dsDatosDocumentoContrato IsNot Nothing Then
                    GenerarCartaBaja(dsDatosDocumentoContrato, nombreDocumento, numPlantilla)
                End If
            End Using

        Catch ex As Exception
            Me.MostrarMensaje(ex.ToString, "Error al generar la carta de Baja")
        End Try
    End Sub

    Private Sub btneliminarIPCpartefija_Click(sender As Object, e As System.EventArgs) Handles btneliminarIPCpartefija.Click
        DelIPC(CLng(txtCtrCodContrato.Text), "S", Usuario.Login)

        Me.AddLoadScript("RecargarContrato();")
    End Sub

    Private Sub btneliminarIPC_Click(sender As Object, e As System.EventArgs) Handles btneliminarIPC.Click
        DelIPC(CLng(txtCtrCodContrato.Text), "N", Usuario.Login)

        Me.AddLoadScript("RecargarContrato();")
    End Sub

    Private Sub btnGeneraCargoCuenta_Click(sender As Object, e As System.EventArgs) Handles btnGeneraCargoCuenta.Click
        Try
            GuardaContrato()
            Dim wsContratacion As New WsContratacion.WsContratacion

            Dim dsDatosDocumentoContrato As New DataSet

            dsDatosDocumentoContrato = descomprimirDataset(wsContratacion.ObtenerDatosDocumentoContrato(txtCtrIdContrato.Text, Usuario.Login))

            hfDCCGenerado.Value = "N"

            If dsDatosDocumentoContrato IsNot Nothing Then
                Dim dtDatosDocumentoContrato As New DataTable

                dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)

                If dtDatosDocumentoContrato IsNot Nothing AndAlso dtDatosDocumentoContrato.Rows.Count = 1 Then
                    If dtDatosDocumentoContrato.Rows(0)("REF_MANDATO").ToString.Trim <> "" Then
                        hfDCCGenerado.Value = "S"
                        GeneraDocumentoOrdenCargoCuenta(dsDatosDocumentoContrato)
                    Else
                        Me.MostrarMensaje("El contrato no tiene una referencia de domiciliación válida. Rellene el IBAN y grabe el contrato antes de generar el documento.")
                    End If
                End If
            End If

        Catch ex As Exception
            Me.MostrarMensaje(ex.ToString, "Error al generar el documento de adeudo en Cuenta")
        End Try
    End Sub

    Private Sub GeneraDocumentoOrdenCargoCuenta(ByVal dsDatosDocumentoContrato As DataSet)
        Try
            hfDCCGenerado.Value = "N"
            If dsDatosDocumentoContrato.Tables.Count > 0 Then

                Dim dtDatosDocumentoContrato As New DataTable

                dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)

                If dtDatosDocumentoContrato IsNot Nothing AndAlso dtDatosDocumentoContrato.Rows.Count = 1 Then
                    hfDCCGenerado.Value = "S"
                    Dim inf As New InfOrdenCargoCuenta()

                    If Not String.IsNullOrEmpty(dtDatosDocumentoContrato.Rows(0)("IBAN").ToString) Then

                        inf.sIndCumplimentado = "S"

                        Dim nomEmpresaPipes As String() = dtDatosDocumentoContrato.Rows(0)("DES_RAZON_SOCIAL").ToString.Trim.ToUpper(CultureInfoSpain).Split("|")
                        Dim nomEmpresa As String = ""

                        If nomEmpresaPipes.Length = 1 Then
                            nomEmpresa = nomEmpresaPipes(0).ToString(CultureInfoSpain)
                        ElseIf nomEmpresaPipes.Length = 2 Then
                            nomEmpresa = String.Concat(nomEmpresaPipes(1), " ", nomEmpresaPipes(0))
                        ElseIf nomEmpresaPipes.Length = 3 Then
                            nomEmpresa = String.Concat(nomEmpresaPipes(2), " ", nomEmpresaPipes(0), " ", nomEmpresaPipes(1))
                        End If

                        Dim desDireccionSoci As String = ""
                        Dim desDomicilioSoci As String = ""
                        Dim sTipoViaSoci As String = ""
                        Dim sCalleSoci As String = ""
                        Dim sNumeroSoci As String = ""
                        Dim sPortalSoci As String = ""
                        Dim sEscaleraSoci As String = ""
                        Dim sPisoSoci As String = ""
                        Dim sPuertaSoci As String = ""
                        Dim sProvincia As String = ""

                        desDireccionSoci = dtDatosDocumentoContrato.Rows(0)("DES_DOMICILIO_SOCI").ToString
                        DomicilioDatos.ObtieneDireccion(desDireccionSoci, sTipoViaSoci, sCalleSoci, sNumeroSoci, sPortalSoci, sEscaleraSoci, sPisoSoci, sPuertaSoci)

                        desDomicilioSoci = String.Concat(sTipoViaSoci, "/", sCalleSoci, ", ", If(sNumeroSoci <> "", "número " & sNumeroSoci, ""), If(sPortalSoci <> "", " portal " & sPortalSoci, ""), If(sEscaleraSoci <> "", " escalera " & sEscaleraSoci, ""), If(sPisoSoci <> "", " " & sPisoSoci & "º", ""), If(sPuertaSoci <> "", " " & sPuertaSoci, ""))

                        sProvincia = String.Concat(UtilidadesSPA.CompletarCodigoPostal(dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI")), "-", dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString, "-", dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString)

                        inf.sTitular = nomEmpresa
                        inf.sReferencia = dtDatosDocumentoContrato.Rows(0)("REF_MANDATO").ToString.Trim
                        inf.sPais = "ESPAÑA"

                        inf.sDireccion = desDomicilioSoci
                        inf.sProvincia = sProvincia

                        Dim Bic As String
                        Dim chBic As Char()

                        If Not String.IsNullOrEmpty(dtDatosDocumentoContrato.Rows(0)("BIC").ToString.Trim) Then
                            Bic = dtDatosDocumentoContrato.Rows(0)("BIC").ToString.Trim
                            chBic = Bic.ToCharArray
                            inf.sBic1 = chBic(0).ToString(CultureInfoSpain)
                            inf.sBic2 = chBic(1).ToString(CultureInfoSpain)
                            inf.sBic3 = chBic(2).ToString(CultureInfoSpain)
                            inf.sBic4 = chBic(3).ToString(CultureInfoSpain)
                            inf.sBic5 = chBic(4).ToString(CultureInfoSpain)
                            inf.sBic6 = chBic(5).ToString(CultureInfoSpain)
                            inf.sBic7 = chBic(6).ToString(CultureInfoSpain)
                            inf.sBic8 = chBic(7).ToString(CultureInfoSpain)
                            inf.sBic9 = chBic(8).ToString(CultureInfoSpain)
                            inf.sBic10 = chBic(9).ToString(CultureInfoSpain)
                            inf.sBic11 = chBic(10).ToString(CultureInfoSpain)
                        Else
                            inf.sBic1 = ""
                            inf.sBic2 = ""
                            inf.sBic3 = ""
                            inf.sBic4 = ""
                            inf.sBic5 = ""
                            inf.sBic6 = ""
                            inf.sBic7 = ""
                            inf.sBic8 = ""
                            inf.sBic9 = ""
                            inf.sBic10 = ""
                            inf.sBic11 = ""
                        End If

                        Dim Iban As String
                        Dim chIban As Char()

                        If Not String.IsNullOrEmpty(dtDatosDocumentoContrato.Rows(0)("IBAN").ToString.Trim) Then
                            Iban = dtDatosDocumentoContrato.Rows(0)("IBAN").ToString.Trim
                            chIban = Iban.ToCharArray
                            inf.sIban1 = chIban(0).ToString(CultureInfoSpain)
                            inf.sIban2 = chIban(1).ToString(CultureInfoSpain)
                            inf.sIban3 = chIban(2).ToString(CultureInfoSpain)
                            inf.sIban4 = chIban(3).ToString(CultureInfoSpain)
                            inf.sIban5 = chIban(4).ToString(CultureInfoSpain)
                            inf.sIban6 = chIban(5).ToString(CultureInfoSpain)
                            inf.sIban7 = chIban(6).ToString(CultureInfoSpain)
                            inf.sIban8 = chIban(7).ToString(CultureInfoSpain)
                            inf.sIban9 = chIban(8).ToString(CultureInfoSpain)
                            inf.sIban10 = chIban(9).ToString(CultureInfoSpain)
                            inf.sIban11 = chIban(10).ToString(CultureInfoSpain)
                            inf.sIban12 = chIban(11).ToString(CultureInfoSpain)
                            inf.sIban13 = chIban(12).ToString(CultureInfoSpain)
                            inf.sIban14 = chIban(13).ToString(CultureInfoSpain)
                            inf.sIban15 = chIban(14).ToString(CultureInfoSpain)
                            inf.sIban16 = chIban(15).ToString(CultureInfoSpain)
                            inf.sIban17 = chIban(16).ToString(CultureInfoSpain)
                            inf.sIban18 = chIban(17).ToString(CultureInfoSpain)
                            inf.sIban19 = chIban(18).ToString(CultureInfoSpain)
                            inf.sIban20 = chIban(19).ToString(CultureInfoSpain)
                            inf.sIban21 = chIban(20).ToString(CultureInfoSpain)
                            inf.sIban22 = chIban(21).ToString(CultureInfoSpain)
                            inf.sIban23 = chIban(22).ToString(CultureInfoSpain)
                            inf.sIban24 = chIban(23).ToString(CultureInfoSpain)
                        Else
                            inf.sIban1 = ""
                            inf.sIban2 = ""
                            inf.sIban3 = ""
                            inf.sIban4 = ""
                            inf.sIban5 = ""
                            inf.sIban6 = ""
                            inf.sIban7 = ""
                            inf.sIban8 = ""
                            inf.sIban9 = ""
                            inf.sIban10 = ""
                            inf.sIban11 = ""
                            inf.sIban12 = ""
                            inf.sIban13 = ""
                            inf.sIban14 = ""
                            inf.sIban15 = ""
                            inf.sIban16 = ""
                            inf.sIban17 = ""
                            inf.sIban18 = ""
                            inf.sIban19 = ""
                            inf.sIban20 = ""
                            inf.sIban21 = ""
                            inf.sIban22 = ""
                            inf.sIban23 = ""
                            inf.sIban24 = ""
                        End If

                    Else
                        inf.sIndCumplimentado = "N"
                    End If

                    inf.NomDocumento = "Contrato " & txtCodContrato.Text & ".docx"

                    inf.CrearInforme(PathDocumento.Contrato)

                    CreateDocument("CARGO_CUENTA", inf.Base64, False, UtilidadesSPA.ObtenerTipoFirma(chkGenerarFirmaOtp.Checked, chkGenerarFirmado.Checked))

                    Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
                    GetDocuments(detallesContrato)
                End If
            End If

        Catch ex As Exception
            Me.MostrarMensaje(ex.ToString, "Error al generar el documento de Cargo en Cuenta")
        End Try

    End Sub

    Private Function ObtenerDomicilio(desDireccion As String) As String
        Dim desDomicilio As String = ""
        Dim sTipoVia As String = ""
        Dim sCalle As String = ""
        Dim sNumero As String = ""
        Dim sPortal As String = ""
        Dim sEscalera As String = ""
        Dim sPiso As String = ""
        Dim sPuerta As String = ""

        DomicilioDatos.ObtieneDireccion(desDireccion, sTipoVia, sCalle, sNumero, sPortal, sEscalera, sPiso, sPuerta)

        desDomicilio = String.Concat(sTipoVia, "/", sCalle, ", ", If(sNumero <> "", "número " & sNumero, ""), If(sPortal <> "", " portal " & sPortal, ""), If(sEscalera <> "", " escalera " & sEscalera, ""), If(sPiso <> "", " " & sPiso & "º", ""), If(sPuerta <> "", " " & sPuerta, ""))
        If Not String.IsNullOrEmpty(sPortal) Then
            desDomicilio = String.Concat(desDomicilio, " PORTAL ", sPortal)
        End If
        If Not String.IsNullOrEmpty(sEscalera) Then
            desDomicilio = String.Concat(desDomicilio, " ESC. ", sEscalera)
        End If
        If Not String.IsNullOrEmpty(sPiso) Then
            desDomicilio = String.Concat(desDomicilio, " PISO ", sPiso)
        End If
        If Not String.IsNullOrEmpty(sPuerta) Then
            desDomicilio = String.Concat(desDomicilio, " PTA. ", sPuerta)
        End If

        Return desDomicilio
    End Function

    Private Shared Function ObtenerNombreEmpresa(desRazonSocial As String) As String
        Dim nombreEmpresaPipes As String() = desRazonSocial.Trim.Split("|")
        Dim nombreEmpresa As String = ""

        If nombreEmpresaPipes.Length = 1 Then
            nombreEmpresa = nombreEmpresaPipes(0)
        ElseIf nombreEmpresaPipes.Length = 2 Then
            nombreEmpresa = String.Concat(nombreEmpresaPipes(1), " ", nombreEmpresaPipes(0))
        ElseIf nombreEmpresaPipes.Length = 3 Then
            nombreEmpresa = String.Concat(nombreEmpresaPipes(2), " ", nombreEmpresaPipes(0), " ", nombreEmpresaPipes(1))
        End If

        Return nombreEmpresa
    End Function

    Private Shared Function FormatearFechaEnTexto(fecha As String) As String
        Dim sDia As String
        Dim sAno As String
        Dim sMes As String

        If Not String.IsNullOrEmpty(fecha) Then
            Dim aFecha As Date = fecha
            sDia = aFecha.Day
            sAno = aFecha.Year
            sMes = UtilidadesSPA.GetTextoMes(aFecha.Month)

            Return String.Concat(sDia, " de ", sMes, " de ", sAno)
        Else
            Return "_____ / _____ / _____ "
        End If
    End Function

    Private Sub GenerarCartaBaja(ByVal dsDatosDocumentoContrato As DataSet, nombreDocumento As String, numPlantilla As Integer)


        If dsDatosDocumentoContrato.Tables.Count > 0 Then

            Dim dtDatosDocumentoContrato As New DataTable

            dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)

            If dtDatosDocumentoContrato IsNot Nothing AndAlso dtDatosDocumentoContrato.Rows.Count = 1 Then

                Dim inf As New InfCartadeBaja(numPlantilla)

                Try
                    inf.NomDocumento = nombreDocumento
                    inf.sRazonSocial = ObtenerNombreEmpresa(dtDatosDocumentoContrato.Rows(0)("DES_RAZON_SOCIAL").ToString)
                    inf.sDomicilio = ObtenerDomicilio(dtDatosDocumentoContrato.Rows(0)("DES_DOMICILIO_SOCI").ToString)
                    inf.sCodPostal = UtilidadesSPA.CompletarCodigoPostal(dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI"))
                    inf.sPoblacion = dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString
                    inf.sProvincia = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                    inf.sNumContrato = txtCtrCodContrato.Text
                    inf.sFecInicio = dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString
                    inf.sFecha = FormatearFechaEnTexto(Date.Now)
                    inf.sFecFin = FormatearFechaEnTexto(dtDatosDocumentoContrato.Rows(0)("FEC_TERMINADO").ToString)
                    inf.sPoblac = dtDatosDocumentoContrato.Rows(0)("POBLACION_CENT_GEST").ToString

                    If numPlantilla = 2 Then
                        inf.sFechaFutura = GetFechaCartasBaja(False)
                    ElseIf numPlantilla = 3 Then
                        inf.sFechaFutura = GetFechaCartasBaja(True)
                        inf.sPrecio = (dtDatosDocumentoContrato.Rows(0)("IMP_TOTAL") / 2).ToString
                    End If

                    inf.CrearInforme(PathDocumento.Contrato)
                Catch ex As Exception
                    Traces.TrackException(ex, tc, pageName, "Error GenerarCartaBaja()")
                    Me.MostrarMensaje(ex.ToString, "Error al generar el documento de Cargo en Cuenta")
                End Try

                Dim documento As New Documento With {.fileName = inf.NomDocumento, .base64StringFile = inf.Base64}
                MostrarDocumento(documento)
            End If
        End If

    End Sub

    Private Sub GeneraDocumentoContrato(ByVal dsDatosDocumentoContrato As DataSet)

        If dsDatosDocumentoContrato.Tables.Count > 0 Then

            Dim dtDatosDocumentoContrato As New DataTable

            dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)

            Select Case dtDatosDocumentoContrato.Rows(0)("TIPO_CONTRATO")

                Case "T", "P"
                    GeneraDocumentoContratoModalidades(dsDatosDocumentoContrato)
                Case "A"
                    GeneraDocumentoContratoAutonomo(dsDatosDocumentoContrato)
                Case "E"
                    GeneraDocumentoContratoActividadesEspecificas(dsDatosDocumentoContrato)
                Case "B"
                    GeneraDocumentoContratoBolsaHoras(dsDatosDocumentoContrato)
            End Select

        End If

    End Sub

    Private Function RellenarCentrosTrabajo(dtCentrosDocumentoContrato As DataTable) As List(Of InfoCentroTrabajo)
        Dim listaCentros As New List(Of InfoCentroTrabajo)

        For Each centro As DataRow In dtCentrosDocumentoContrato.Rows

            Dim desDireccion As String = ""
            Dim desDomicilio As String = ""
            Dim sTipoVia As String = ""
            Dim sCalle As String = ""
            Dim sNumero As String = ""
            Dim sPortal As String = ""
            Dim sEscalera As String = ""
            Dim sPiso As String = ""
            Dim sPuerta As String = ""

            desDireccion = centro("DES_DOMICILIO").ToString

            DomicilioDatos.ObtieneDireccion(desDireccion, sTipoVia, sCalle, sNumero, sPortal, sEscalera, sPiso, sPuerta)

            desDomicilio = String.Concat(sTipoVia, "/", sCalle, ", ", If(sNumero <> "", "número " & sNumero, ""), If(sPortal <> "", " portal " & sPortal, ""), If(sEscalera <> "", " escalera " & sEscalera, ""), If(sPiso <> "", " " & sPiso & "º", ""), If(sPuerta <> "", " " & sPuerta, ""))

            listaCentros.Add(New InfoCentroTrabajo() With {.CNAE = centro("COD_ACTIVIDAD").ToString, .NumTrabajadores = centro("CAN_TRAB_TOTAL").ToString, .CodPostal = UtilidadesSPA.CompletarCodigoPostal(centro("COD_POSTAL")), .Domicilio = desDomicilio, .Poblacion = centro("DES_POBLACION").ToString, .Provincia = centro("DES_PROVINCIA").ToString})

        Next

        Return listaCentros
    End Function

    Private Sub GeneraDocumentoContratoModalidades(ByVal dsDatosDocumentoContrato As DataSet)

        If dsDatosDocumentoContrato.Tables.Count > 0 Then

            Dim dtDatosDocumentoContrato As New DataTable
            Dim dtCentrosDocumentoContrato As New DataTable
            Dim dtProductosDocumentoContrato As New DataTable
            Dim dtFirmantesDocumentoContrato As New DataTable
            Dim dtSumaTrabDocumentoContrato As New DataTable
            Dim dtFirmSPFMDocumentoContrato As New DataTable
            Dim dtPlantillasDocumentoContrato As New DataTable
            Dim dtPruebasExternasDocumentoPresupuesto As New DataTable
            Dim dtClausuladoTarifas_2020 As New DataTable

            Dim dtPruebasVSI_Reconocimientos As New DataTable
            Dim dtPruebasVSI_Analiticas As New DataTable
            Dim dtPruebasVSI_PruebasComplementarias As New DataTable
            Dim dtPruebasVSI_Vacunas As New DataTable
            Dim dtFirmanteTerritorial As New DataTable

            dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)
            dtCentrosDocumentoContrato = dsDatosDocumentoContrato.Tables(1)
            dtProductosDocumentoContrato = dsDatosDocumentoContrato.Tables(2)
            dtFirmantesDocumentoContrato = dsDatosDocumentoContrato.Tables(3)
            dtSumaTrabDocumentoContrato = dsDatosDocumentoContrato.Tables(4)
            dtFirmSPFMDocumentoContrato = dsDatosDocumentoContrato.Tables(5)
            dtPlantillasDocumentoContrato = dsDatosDocumentoContrato.Tables(6)
            dtPruebasExternasDocumentoPresupuesto = dsDatosDocumentoContrato.Tables(9)
            dtClausuladoTarifas_2020 = dsDatosDocumentoContrato.Tables(10)

            dtPruebasVSI_Reconocimientos = dsDatosDocumentoContrato.Tables(11)
            dtPruebasVSI_Analiticas = dsDatosDocumentoContrato.Tables(12)
            dtPruebasVSI_PruebasComplementarias = dsDatosDocumentoContrato.Tables(13)
            dtPruebasVSI_Vacunas = dsDatosDocumentoContrato.Tables(14)
            dtFirmanteTerritorial = dsDatosDocumentoContrato.Tables(15)

            Dim num_contrato_string As String
            If txtContratoSAP.Text = "" Then
                num_contrato_string = txtCtrCodContrato.Text
            Else
                num_contrato_string = txtContratoSAP.Text
            End If

            Dim inf As New InfContratoModalidades()

            inf.sNumContrato = num_contrato_string

            inf.sNumTrabEmpresa = dtSumaTrabDocumentoContrato.Rows(0)("SUM_TRAB_TOTAL").ToString

            If dtCentrosDocumentoContrato IsNot Nothing AndAlso dtCentrosDocumentoContrato.Rows.Count > 0 AndAlso Not chkSinCentro.Checked Then
                inf.ListaCentrosTrabajo.AddRange(RellenarCentrosTrabajo(dtCentrosDocumentoContrato))
            End If

            If dtDatosDocumentoContrato.Rows.Count > 0 Then

                inf.sLocalidad = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                inf.sTribunal = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                inf.sFecha = dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString

                Dim nomEmpresaPipes As String() = dtDatosDocumentoContrato.Rows(0)("DES_RAZON_SOCIAL").ToString.Trim.Split("|")
                Dim nomEmpresa As String = ""

                If nomEmpresaPipes.Length = 1 Then
                    nomEmpresa = nomEmpresaPipes(0).ToString(CultureInfoSpain)
                ElseIf nomEmpresaPipes.Length = 2 Then
                    nomEmpresa = String.Concat(nomEmpresaPipes(1), " ", nomEmpresaPipes(0))
                ElseIf nomEmpresaPipes.Length = 3 Then
                    nomEmpresa = String.Concat(nomEmpresaPipes(2), " ", nomEmpresaPipes(0), " ", nomEmpresaPipes(1))
                End If

                inf.sRazonSocial = nomEmpresa

                inf.sCIFEmpresa = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString

                Dim desDireccionSoci As String = ""
                Dim desDomicilioSoci As String = ""
                Dim sTipoViaSoci As String = ""
                Dim sCalleSoci As String = ""
                Dim sNumeroSoci As String = ""
                Dim sPortalSoci As String = ""
                Dim sEscaleraSoci As String = ""
                Dim sPisoSoci As String = ""
                Dim sPuertaSoci As String = ""

                desDireccionSoci = dtDatosDocumentoContrato.Rows(0)("DES_DOMICILIO_SOCI").ToString
                DomicilioDatos.ObtieneDireccion(desDireccionSoci, sTipoViaSoci, sCalleSoci, sNumeroSoci, sPortalSoci, sEscaleraSoci, sPisoSoci, sPuertaSoci)

                desDomicilioSoci = String.Concat(sTipoViaSoci, "/", sCalleSoci, ", ", If(sNumeroSoci <> "", "número " & sNumeroSoci, ""), If(sPortalSoci <> "", " portal " & sPortalSoci, ""), If(sEscaleraSoci <> "", " escalera " & sEscaleraSoci, ""), If(sPisoSoci <> "", " " & sPisoSoci & "º", ""), If(sPuertaSoci <> "", " " & sPuertaSoci, ""))

                inf.sDomicilioSocialEmpresa = desDomicilioSoci
                inf.sCodigoPostalEmpresa = UtilidadesSPA.CompletarCodigoPostal(dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI"))
                inf.sPoblacionEmpresa = dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString
                inf.sProvincia = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString

                desDomicilioSoci = String.Concat(desDomicilioSoci, ", ", inf.sCodigoPostalEmpresa, ", ", inf.sPoblacionEmpresa, " (", inf.sProvincia, ")")

                inf.sDireccion = desDomicilioSoci

                inf.sCodCNAE = dtDatosDocumentoContrato.Rows(0)("COD_ACTIVIDAD").ToString
                inf.sDesCNAE = dtDatosDocumentoContrato.Rows(0)("DES_ACTIVIDAD").ToString

                inf.sImporteSeguridad = dtDatosDocumentoContrato.Rows(0)("IMP_SEGURIDAD").ToString
                inf.sImporteHigiene = dtDatosDocumentoContrato.Rows(0)("IMP_HIGIENE").ToString
                inf.sImporteErgonomia = dtDatosDocumentoContrato.Rows(0)("IMP_ERGONOMIA").ToString
                inf.sImporteMT = dtDatosDocumentoContrato.Rows(0)("IMP_MEDICINA").ToString
                inf.sImporteSHE = dtDatosDocumentoContrato.Rows(0)("IMP_SHE").ToString
                inf.sImporteTotal = dtDatosDocumentoContrato.Rows(0)("IMP_TOTAL").ToString
                inf.InfoModalidades = New InfoModalidades() With {
                        .IndSeguridad = chkModST.Checked,
                        .IndHigiene = chkModHI.Checked,
                        .IndErgonomia = chkModEP.Checked,
                        .IndMedicina = chkModMT.Checked,
                        .ImporteSeguridad = IIf(inf.sImporteSeguridad <> "", inf.sImporteSeguridad, "0,00"),
                        .ImporteHigiene = IIf(inf.sImporteHigiene <> "", inf.sImporteHigiene, "0,00"),
                        .ImporteErgonomia = IIf(inf.sImporteErgonomia <> "", inf.sImporteErgonomia, "0,00"),
                        .ImporteMedicina = IIf(inf.sImporteMT <> "", inf.sImporteMT, "0,00"),
                        .ImporteTotal = IIf(inf.sImporteTotal <> "", inf.sImporteTotal, "0,00")
                    }

                inf.sImporteRecoAP = dtDatosDocumentoContrato.Rows(0)("IMP_RECO_ALTA_PEL").ToString
                inf.sImporteRecoBP = dtDatosDocumentoContrato.Rows(0)("IMP_RECO_BAJA_PEL").ToString

                inf.sPeriodoFactura = dtDatosDocumentoContrato.Rows(0)("PERIODO_FACTURA").ToString
                inf.sPlazoVencimiento = dtDatosDocumentoContrato.Rows(0)("IND_PLAZO_VENC").ToString
                inf.sModoPago = dtDatosDocumentoContrato.Rows(0)("MODO_PAGO").ToString
                inf.sFormacionOnline = dtDatosDocumentoContrato.Rows(0)("FORMACION_ONLINE").ToString

                Dim iIncluye As Integer = 0

                Dim erroresTryParse As Boolean = Integer.TryParse(dtDatosDocumentoContrato.Rows(0)("CAN_MIN_TRAB_RECO"), iIncluye)

                If iIncluye > 0 Then
                    inf.sIncluye = "El importe reflejado en el apartado de Medicina del Trabajo - Vigilancia de la Salud incluye la realización de " & iIncluye.ToString & " reconocimiento médico."
                Else
                    inf.sIncluye = ""
                End If

                inf.sFechaFutura = dtDatosDocumentoContrato.Rows(0)("FEC_INICIO_FACT").ToString

                If inf.sFechaFutura <> "" Then
                    inf.sIndFechaFutura = "S"
                Else
                    inf.sIndFechaFutura = "N"
                End If

            End If

            If dtFirmantesDocumentoContrato.Rows.Count > 0 Then

                If dtFirmantesDocumentoContrato.Rows.Count = 1 Then

                    Dim nomFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")

                    If nomFirmantePipes.Length = 1 Then
                        inf.sFirmanteEmpresa = nomFirmantePipes(0)
                    ElseIf nomFirmantePipes.Length = 2 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
                    ElseIf nomFirmantePipes.Length = 3 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
                    Else
                        inf.sFirmanteEmpresa = ""
                    End If


                    inf.sTipoDoc = dtFirmantesDocumentoContrato.Rows(0)("TIPO_DOCUMENTO").ToString
                    inf.sNIF = dtFirmantesDocumentoContrato.Rows(0)("NIF").ToString.Trim
                    inf.sCargo1 = String.Concat(" en calidad de ", dtFirmantesDocumentoContrato.Rows(0)("DES_CARGO").ToString().ToUpper(CultureInfoSpain))

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString) Then
                        inf.sNotario = dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        Dim textNotario As String = TEXTO_NOTARIO

                        textNotario = textNotario.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(0)("FEC_NOTARIO1").ToString)
                        textNotario = textNotario.Replace("PODER", dtFirmantesDocumentoContrato.Rows(0)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString) Then
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString)
                        Else
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("POBLACION").ToString)
                        End If

                        textNotario = textNotario.Replace("NOM_NOTARIO", nomNotario)

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            inf.sNotario = ""
                        Else
                            inf.sNotario = textNotario
                        End If

                    End If

                    inf.sMasFirmantes2 = ""
                    inf.sMasFirmantes3 = ""

                End If

                If dtFirmantesDocumentoContrato.Rows.Count = 2 Then

                    Dim nomFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")

                    If nomFirmantePipes.Length = 1 Then
                        inf.sFirmanteEmpresa = nomFirmantePipes(0)
                    ElseIf nomFirmantePipes.Length = 2 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
                    ElseIf nomFirmantePipes.Length = 3 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
                    Else
                        inf.sFirmanteEmpresa = ""
                    End If

                    inf.sTipoDoc = dtFirmantesDocumentoContrato.Rows(0)("TIPO_DOCUMENTO").ToString
                    inf.sNIF = dtFirmantesDocumentoContrato.Rows(0)("NIF").ToString.Trim
                    inf.sCargo1 = String.Concat(" en calidad de ", dtFirmantesDocumentoContrato.Rows(0)("DES_CARGO").ToString.ToUpper(CultureInfoSpain).Trim)

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString) Then
                        inf.sNotario = dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If


                        Dim textNotario As String = TEXTO_NOTARIO

                        textNotario = textNotario.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(0)("FEC_NOTARIO1").ToString)
                        textNotario = textNotario.Replace("PODER", dtFirmantesDocumentoContrato.Rows(0)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString) Then
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString)
                        Else
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("POBLACION").ToString)
                        End If

                        textNotario = textNotario.Replace("NOM_NOTARIO", nomNotario)

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            inf.sNotario = ""
                        Else
                            inf.sNotario = textNotario
                        End If

                    End If

                    Dim textoFirmante As String = TEXTO_FIRMANTE
                    Dim textNotario2 As String = TEXTO_NOTARIO

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(1)("DES_NOTARIO").ToString) Then
                        textNotario2 = dtFirmantesDocumentoContrato.Rows(1)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(1)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        textNotario2 = textNotario2.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(1)("FEC_NOTARIO1").ToString)
                        textNotario2 = textNotario2.Replace("PODER", dtFirmantesDocumentoContrato.Rows(1)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(1)("PROVINCIA").ToString) Then
                            textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(1)("PROVINCIA").ToString)
                        Else
                            textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(1)("POBLACION").ToString)
                        End If

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            textNotario2 = ""
                        Else
                            textNotario2 = textNotario2.Replace("NOM_NOTARIO", nomNotario)
                        End If

                    End If

                    Dim nombFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(1)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")
                    Dim nombFirmante As String = ""

                    If nombFirmantePipes.Length = 1 Then
                        nombFirmante = nombFirmantePipes(0)
                    ElseIf nombFirmantePipes.Length = 2 Then
                        nombFirmante = String.Concat(nombFirmantePipes(1), " ", nombFirmantePipes(0))
                    ElseIf nombFirmantePipes.Length = 3 Then
                        nombFirmante = String.Concat(nombFirmantePipes(2), " ", nombFirmantePipes(0), " ", nombFirmantePipes(1))
                    End If

                    textoFirmante = textoFirmante.Replace("NOMBRE_FIRMANTE", nombFirmante)
                    textoFirmante = textoFirmante.Replace("TIPO_DOCUMENTO", dtFirmantesDocumentoContrato.Rows(1)("TIPO_DOCUMENTO").ToString)
                    textoFirmante = textoFirmante.Replace("IDENTIFICADOR", dtFirmantesDocumentoContrato.Rows(1)("NIF").ToString.Trim)
                    textoFirmante = textoFirmante.Replace("CARGO", dtFirmantesDocumentoContrato.Rows(1)("DES_CARGO").ToString.ToUpper(CultureInfoSpain).Trim)
                    textoFirmante = textoFirmante.Replace("NOTARIO", textNotario2)


                    inf.sMasFirmantes2 = textoFirmante

                    inf.sMasFirmantes3 = ""

                End If

            End If

            DocumentacionRellenaFirmantesQp(inf, dtFirmSPFMDocumentoContrato)

            inf.sFrase = ""

            UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma, inf.NomPersonaFirma, inf.NumFirmantes, ccdCtrDirectivo1)
            If Not String.IsNullOrEmpty(dtFirmSPFMDocumentoContrato.Rows(0)("COD_EMPLEADO2").ToString) Then
                UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma2, inf.NomPersonaFirma2, inf.NumFirmantes, ccdCtrDirectivo2)
            End If

            If chkGenerarFirmado.Checked Then
                inf.sIndFirma = "S"
            ElseIf chkGenerarFirmaOtp.Checked Then
                inf.sIndFirma = "O"
            Else
                inf.sIndFirma = "N"
            End If

            Dim tienePruebaAbsentismo As Boolean = False

            If dtPruebasExternasDocumentoPresupuesto IsNot Nothing AndAlso dtPruebasExternasDocumentoPresupuesto.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasExternasDocumentoPresupuesto.Rows

                    Dim impTotalPrueba As Decimal
                    impTotalPrueba = pruebaVSI("IMP_UNI_INC") * pruebaVSI("NUM_INCLUIDAS")

                    inf.ListaPruebasExternas.Add(New InfoPruebasExternas() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .PrecioPruebaExterna = pruebaVSI("IMP_UNI_INC").ToString, .numPruebasExternas = pruebaVSI("NUM_INCLUIDAS").ToString, .PrecioTotalPruebaExterna = impTotalPrueba.ToString, .PrecioExcluidoPruebaExterna = pruebaVSI("IMP_UNI_EXC"), .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA")})

                    If pruebaVSI("COD_PRUEBA") = COD_PRUEBA_ABSENTISMOS Then
                        tienePruebaAbsentismo = True
                        If pruebaVSI("IMP_UNI_EXC") > 0 Then
                            inf.IndAbsentismo = True
                            inf.ImporteAbsentismo = pruebaVSI("IMP_UNI_EXC")
                        End If
                    End If
                Next
            End If

            If Not tienePruebaAbsentismo AndAlso dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA") > 0 Then
                inf.IndAbsentismo = True
                inf.ImporteAbsentismo = dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA")
            End If

            If dtPruebasVSI_Reconocimientos IsNot Nothing AndAlso dtPruebasVSI_Reconocimientos.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_Reconocimientos.Rows
                    inf.ListaPruebasExternasReconocimientos.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString, .ImportePruebaExternaRECOBR = pruebaVSI("IMPORTE_RECOBR").ToString})
                Next
            End If
            If dtPruebasVSI_Analiticas IsNot Nothing AndAlso dtPruebasVSI_Analiticas.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_Analiticas.Rows
                    inf.ListaPruebasExternasAnaliticas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                Next
            End If
            If dtPruebasVSI_PruebasComplementarias IsNot Nothing AndAlso dtPruebasVSI_PruebasComplementarias.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_PruebasComplementarias.Rows
                    inf.ListaPruebasExternasPruebasComplementarias.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                Next
            End If
            If dtPruebasVSI_Vacunas IsNot Nothing AndAlso dtPruebasVSI_Vacunas.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_Vacunas.Rows
                    inf.ListaPruebasExternasVacunas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                Next
            End If

            If dtClausuladoTarifas_2020 IsNot Nothing Then
                If dtClausuladoTarifas_2020.Rows.Count > 0 Then

                    Dim totalCadenaClausulado As String = ""

                    For Each clausulado As DataRow In dtClausuladoTarifas_2020.Rows
                        totalCadenaClausulado = String.Concat(totalCadenaClausulado, " ", clausulado(0))
                    Next
                    inf.sClausuladoTarifa2020 = totalCadenaClausulado
                Else
                    inf.sClausuladoTarifa2020 = "VACÍO"
                End If
            Else
                inf.sClausuladoTarifa2020 = "VACÍO"
            End If

            inf.NomDocumento = "Contrato " & txtCodContrato.Text & ".docx"

            Dim indSepa = rblTipoPago.SelectedValue = "D"
            inf.IndSepa = indSepa

            inf.CrearInforme(PathDocumento.Contrato)

            If indSepa Then
                Dim infCargoCuenta As New InfOrdenCargoCuentaFirma()
                AsignarMarcadoresSepa(infCargoCuenta, inf, dtDatosDocumentoContrato.Rows)
                infCargoCuenta.IndNumAnexo = "III"
                infCargoCuenta.CrearInforme(PathDocumento.Contrato)
                inf.Base64 = WordUtil.CombinarDocumentos(inf.Base64, infCargoCuenta.Base64)
            End If

            Dim isPdf As Boolean = False

            If chkGenerarFirmado.Checked OrElse chkGenerarFirmaOtp.Checked Then
                CambiarCaracteristicasDocumentoAPdf(inf, "Contrato " & txtCtrCodContrato.Text & ".pdf", txtCtrCodContrato.Text, isPdf, inf.Base64)
            End If

            Dim documento As String = CreateDocument("MODALIDADES", inf.Base64, isPdf, UtilidadesSPA.ObtenerTipoFirma(chkGenerarFirmaOtp.Checked, chkGenerarFirmado.Checked))

            If documento <> "" Then
                Me.AddLoadScript("visualizarDocumentoDigital();")
            End If

            Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
            GetDocuments(detallesContrato)

        End If
    End Sub

    Private Sub GeneraDocumentoContratoActividadesEspecificas(ByVal dsDatosDocumentoContrato As DataSet)

        If dsDatosDocumentoContrato.Tables.Count > 0 Then

            Dim documento As String = ""

            Dim dtDatosDocumentoContrato As New DataTable
            Dim dtCentrosDocumentoContrato As New DataTable
            Dim dtProductosDocumentoContrato As New DataTable
            Dim dtFirmantesDocumentoContrato As New DataTable
            Dim dtSumaTrabDocumentoContrato As New DataTable
            Dim dtFirmSPFMDocumentoContrato As New DataTable
            Dim dtDatosDocumentoAnaliticas As New DataTable
            Dim dtPruebasExternasDocumentoPresupuesto As New DataTable
            Dim dtClausuladoTarifas_2020 As New DataTable

            Dim dtPruebasVSI_Reconocimientos As New DataTable
            Dim dtPruebasVSI_Analiticas As New DataTable
            Dim dtPruebasVSI_PruebasComplementarias As New DataTable
            Dim dtPruebasVSI_Vacunas As New DataTable
            Dim dtFirmanteTerritorial As New DataTable

            dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)
            dtCentrosDocumentoContrato = dsDatosDocumentoContrato.Tables(1)
            dtProductosDocumentoContrato = dsDatosDocumentoContrato.Tables(2)
            dtFirmantesDocumentoContrato = dsDatosDocumentoContrato.Tables(3)
            dtSumaTrabDocumentoContrato = dsDatosDocumentoContrato.Tables(4)
            dtFirmSPFMDocumentoContrato = dsDatosDocumentoContrato.Tables(5)
            dtDatosDocumentoAnaliticas = dsDatosDocumentoContrato.Tables(8)
            dtPruebasExternasDocumentoPresupuesto = dsDatosDocumentoContrato.Tables(9)
            dtClausuladoTarifas_2020 = dsDatosDocumentoContrato.Tables(10)

            dtPruebasVSI_Reconocimientos = dsDatosDocumentoContrato.Tables(11)
            dtPruebasVSI_Analiticas = dsDatosDocumentoContrato.Tables(12)
            dtPruebasVSI_PruebasComplementarias = dsDatosDocumentoContrato.Tables(13)
            dtPruebasVSI_Vacunas = dsDatosDocumentoContrato.Tables(14)
            dtFirmanteTerritorial = dsDatosDocumentoContrato.Tables(15)

            Dim impRecosBaja As Decimal = 0
            Dim impRecosAlta As Decimal = 0

            If dtFirmantesDocumentoContrato.Rows.Count = 0 Then
                Me.AddLoadScript("forzarDescargaUltimoFicheroGenerado();")
            Else

                Dim num_contrato_string As String
                If txtContratoSAP.Text = "" Then
                    num_contrato_string = txtCtrCodContrato.Text
                Else
                    num_contrato_string = txtContratoSAP.Text
                End If

                documento = Constante.ObtenerValor("RUTA_DOCUMENTOS", TEXTO_SPA).ToString & "Contrato Express " & num_contrato_string & ".docx"

                Dim bIncluyeMedicina As Boolean = False
                For Each producto As DataRow In dtProductosDocumentoContrato.Rows
                    If producto("IND_AREA") = "M" Or producto("IND_AREA") = "A" Then
                        bIncluyeMedicina = True
                        Exit For
                    End If
                Next

                Dim inf As New InfContratoActividadesEspecificas()

                inf.sNumContrato = num_contrato_string
                inf.sLocalidad = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                inf.sTribunal = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                inf.sFecha = dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString
                inf.sFechaFutura = dtDatosDocumentoContrato.Rows(0)("FEC_INICIO_FACT").ToString

                If inf.sFechaFutura <> "" Then
                    inf.sIndFechaFutura = "S"
                Else
                    inf.sIndFechaFutura = "N"
                End If

                If dtCentrosDocumentoContrato IsNot Nothing AndAlso dtCentrosDocumentoContrato.Rows.Count > 0 Then
                    inf.ListaCentrosTrabajo.AddRange(RellenarCentrosTrabajo(dtCentrosDocumentoContrato))
                End If

                If dtDatosDocumentoContrato.Rows.Count > 0 Then

                    Dim fecha As Date
                    Date.TryParse(dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString, fecha)
                    inf.sPlazoVencimiento = String.Concat(dtDatosDocumentoContrato.Rows(0)("IND_PLAZO_VENC").ToString, " días")

                    inf.sDia = fecha.Day.ToString(CultureInfoSpain)
                    inf.sAnno = fecha.Year.ToString(CultureInfoSpain)
                    inf.sMes = UtilidadesSPA.GetTextoMes(fecha.Month)

                    Dim nomEmpresaPipes As String() = dtDatosDocumentoContrato.Rows(0)("DES_RAZON_SOCIAL").ToString.Trim.Split("|")
                    Dim nomEmpresa As String = ""

                    If nomEmpresaPipes.Length = 1 Then
                        nomEmpresa = nomEmpresaPipes(0).ToString(CultureInfoSpain)
                    ElseIf nomEmpresaPipes.Length = 2 Then
                        nomEmpresa = String.Concat(nomEmpresaPipes(1), " ", nomEmpresaPipes(0))
                    ElseIf nomEmpresaPipes.Length = 3 Then
                        nomEmpresa = String.Concat(nomEmpresaPipes(2), " ", nomEmpresaPipes(0), " ", nomEmpresaPipes(1))
                    End If

                    inf.sEmpresa = nomEmpresa
                    inf.sNumCIF = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString.Trim

                    inf.sIndRenovable = dtDatosDocumentoContrato.Rows(0)("IND_RENOVABLE").ToString.Trim

                    inf.sProv = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString.Trim

                    inf.sTribunal = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString.Trim

                    Dim desDireccionSoci As String = ""
                    Dim desDomicilioSoci As String = ""
                    Dim sTipoViaSoci As String = ""
                    Dim sCalleSoci As String = ""
                    Dim sNumeroSoci As String = ""
                    Dim sPortalSoci As String = ""
                    Dim sEscaleraSoci As String = ""
                    Dim sPisoSoci As String = ""
                    Dim sPuertaSoci As String = ""

                    inf.sRazonSocial = nomEmpresa
                    inf.sCIFEmpresa = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString
                    inf.sNIFFirmanteEmpresa = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString
                    inf.sCodigoPostalEmpresa = UtilidadesSPA.CompletarCodigoPostal(dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI"))
                    inf.sPoblacionEmpresa = dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString
                    inf.sProvincia = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                    inf.sCodCNAE = dtDatosDocumentoContrato.Rows(0)("COD_ACTIVIDAD").ToString
                    inf.sDesCNAE = dtDatosDocumentoContrato.Rows(0)("DES_ACTIVIDAD").ToString

                    inf.sNumTrabEmpresa = dtSumaTrabDocumentoContrato.Rows(0)("SUM_TRAB_TOTAL").ToString

                    desDireccionSoci = dtDatosDocumentoContrato.Rows(0)("DES_DOMICILIO_SOCI").ToString
                    DomicilioDatos.ObtieneDireccion(desDireccionSoci, sTipoViaSoci, sCalleSoci, sNumeroSoci, sPortalSoci, sEscaleraSoci, sPisoSoci, sPuertaSoci)

                    desDomicilioSoci = String.Concat(sTipoViaSoci, "/", sCalleSoci, ", ", If(sNumeroSoci <> "", "número " & sNumeroSoci, ""), If(sPortalSoci <> "", " portal " & sPortalSoci, ""), If(sEscaleraSoci <> "", " escalera " & sEscaleraSoci, ""), If(sPisoSoci <> "", " " & sPisoSoci & "º", ""), If(sPuertaSoci <> "", " " & sPuertaSoci, ""))

                    inf.sDomicilioSocialEmpresa = desDomicilioSoci

                    'ASG 20151223 Añado el código postal y la provincia a la dirección del cliente.
                    desDomicilioSoci = String.Concat(desDomicilioSoci, ", ", dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI").ToString, ", ", dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString, " (", dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString, ")")
                    inf.sDireccion = desDomicilioSoci

                    inf.sImporteRecoAP = dtDatosDocumentoContrato.Rows(0)("IMP_RECO_ALTA_PEL").ToString
                    inf.sImporteRecoBP = dtDatosDocumentoContrato.Rows(0)("IMP_RECO_BAJA_PEL").ToString
                    inf.sEurMT = dtDatosDocumentoContrato.Rows(0)("IMP_PROD_MT").ToString
                    inf.sEurTotal = dtDatosDocumentoContrato.Rows(0)("IMP_TOTAL_PRODUCTOS").ToString

                    inf.sPeriodoFactura = dtDatosDocumentoContrato.Rows(0)("PERIODO_FACTURA").ToString
                    inf.sPlazoVencimiento = dtDatosDocumentoContrato.Rows(0)("IND_PLAZO_VENC").ToString
                    inf.sModoPago = dtDatosDocumentoContrato.Rows(0)("MODO_PAGO").ToString

                    If String.Compare(dtDatosDocumentoContrato.Rows(0)("IND_FACT_ELECTRONICA").ToString, "S", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                        inf.sFactElectronica = "La empresa acepta que la modalidad de facturación utilizada sea en formato electrónico."
                    Else
                        inf.sFactElectronica = ""
                    End If

                    If String.Compare(dtDatosDocumentoContrato.Rows(0)("IND_FACT_RECONOCI").ToString(), "S", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                        Dim iIncluye As Integer = 0
                        Integer.TryParse(dtDatosDocumentoContrato.Rows(0)("CAN_MIN_TRAB_RECO"), iIncluye)
                        Decimal.TryParse(dtDatosDocumentoContrato.Rows(0)("IMP_RECO_BAJA_PEL").ToString.Trim, impRecosBaja)
                        Decimal.TryParse(dtDatosDocumentoContrato.Rows(0)("IMP_RECO_ALTA_PEL").ToString.Trim, impRecosAlta)
                        inf.sRecos = String.Concat("Reconocimientos médicos, que se facturarán cada uno a razón de ", impRecosBaja.ToString(CultureInfoSpain), "€ para trabajadores de baja peligrosidad y " & impRecosAlta.ToString(CultureInfoSpain) & "€ para trabajadores de alta peligrosidad")
                        If iIncluye > 0 Then
                            inf.sRecos = String.Concat(inf.sRecos, ". Se incluye la realización de " & iIncluye.ToString(CultureInfoSpain) & " reconocimiento médico.")
                        End If
                    Else
                        inf.sRecos = ""
                    End If

                    If String.Compare(dtDatosDocumentoContrato.Rows(0)("IND_FACT_ANALITICA").ToString(), "S", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                        If dtDatosDocumentoAnaliticas IsNot Nothing Then
                            If dtDatosDocumentoAnaliticas.Rows.Count > 0 Then
                                Dim bPerfilG33 As Boolean = False
                                Dim dPrecioAnalitica As Decimal = 0
                                For Each analitica As DataRow In dtDatosDocumentoAnaliticas.Rows
                                    Decimal.TryParse(analitica("IMP_ANALITICA").ToString, dPrecioAnalitica)
                                    If String.Compare(analitica("LITERAL_PERFIL").ToString.Trim, "PERFIL G33", StringComparison.InvariantCultureIgnoreCase) = 0 AndAlso dPrecioAnalitica = 0 Then
                                        bPerfilG33 = True
                                    End If
                                Next
                                If bPerfilG33 Then
                                    inf.sNota3 = "- Quedan excluidos los costes de la analítica que se facturarán aparte excepto perfil G33."
                                Else
                                    inf.sNota3 = "- Quedan excluidos los costes de la analítica que se facturarán aparte."
                                End If
                            Else
                                inf.sNota3 = "- Quedan excluidos los costes de la analítica que se facturarán aparte."
                            End If
                        Else
                            inf.sNota3 = "- Quedan excluidos los costes de la analítica que se facturarán aparte."
                        End If
                    Else
                        inf.sNota3 = ""
                    End If

                End If

                If dtFirmantesDocumentoContrato.Rows.Count = 1 Then

                    Dim nomFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")

                    If nomFirmantePipes.Length = 1 Then
                        inf.sFirmanteEmpresa = nomFirmantePipes(0)
                    ElseIf nomFirmantePipes.Length = 2 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
                    ElseIf nomFirmantePipes.Length = 3 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
                    End If

                    inf.sTipoDoc = dtFirmantesDocumentoContrato.Rows(0)("TIPO_DOCUMENTO").ToString
                    inf.sNIF = dtFirmantesDocumentoContrato.Rows(0)("NIF").ToString.Trim
                    inf.sCargo1 = String.Concat(" en calidad de ", dtFirmantesDocumentoContrato.Rows(0)("DES_CARGO").ToString.ToUpper(CultureInfoSpain))

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString) Then
                        inf.sNotario = dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        Dim textNotario As String = TEXTO_NOTARIO

                        textNotario = textNotario.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(0)("FEC_NOTARIO1").ToString)
                        textNotario = textNotario.Replace("PODER", dtFirmantesDocumentoContrato.Rows(0)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString) Then
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString)
                        Else
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("POBLACION").ToString)
                        End If

                        textNotario = textNotario.Replace("NOM_NOTARIO", nomNotario)

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            inf.sNotario = ""
                        Else
                            inf.sNotario = textNotario
                        End If

                    End If

                    inf.sMasFirmantes2 = ""


                End If

                If dtFirmantesDocumentoContrato.Rows.Count = 2 Then

                    Dim nomFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")

                    If nomFirmantePipes.Length = 1 Then
                        inf.sFirmanteEmpresa = nomFirmantePipes(0)
                    ElseIf nomFirmantePipes.Length = 2 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
                    ElseIf nomFirmantePipes.Length = 3 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
                    End If

                    inf.sTipoDoc = dtFirmantesDocumentoContrato.Rows(0)("TIPO_DOCUMENTO").ToString
                    inf.sCargo1 = String.Concat(" en calidad de ", dtFirmantesDocumentoContrato.Rows(0)("DES_CARGO").ToString.ToUpper(CultureInfoSpain))

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString) Then
                        inf.sNotario = dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        Dim textNotario As String = TEXTO_NOTARIO

                        textNotario = textNotario.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(0)("FEC_NOTARIO1").ToString)
                        textNotario = textNotario.Replace("PODER", dtFirmantesDocumentoContrato.Rows(0)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString) Then
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString)
                        Else
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("POBLACION").ToString)
                        End If

                        textNotario = textNotario.Replace("NOM_NOTARIO", nomNotario)

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            inf.sNotario = ""
                        Else
                            inf.sNotario = textNotario
                        End If

                    End If

                    Dim textoFirmante As String = TEXTO_FIRMANTE
                    Dim textNotario2 As String = TEXTO_NOTARIO

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(1)("DES_NOTARIO").ToString) Then
                        textNotario2 = dtFirmantesDocumentoContrato.Rows(1)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(1)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        textNotario2 = textNotario2.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(1)("FEC_NOTARIO1").ToString)
                        textNotario2 = textNotario2.Replace("PODER", dtFirmantesDocumentoContrato.Rows(1)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(1)("PROVINCIA").ToString) Then
                            textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(1)("PROVINCIA").ToString)
                        Else
                            textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(1)("POBLACION").ToString)
                        End If

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            textNotario2 = ""
                        Else
                            textNotario2 = textNotario2.Replace("NOM_NOTARIO", nomNotario)
                        End If


                    End If

                    Dim nombFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(1)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")
                    Dim nombFirmante As String = ""

                    If nombFirmantePipes.Length = 1 Then
                        nombFirmante = nombFirmantePipes(0)
                    ElseIf nombFirmantePipes.Length = 2 Then
                        nombFirmante = String.Concat(nombFirmantePipes(1), " ", nombFirmantePipes(0))
                    ElseIf nombFirmantePipes.Length = 3 Then
                        nombFirmante = String.Concat(nombFirmantePipes(2), " ", nombFirmantePipes(0), " ", nombFirmantePipes(1))
                    End If

                    textoFirmante = textoFirmante.Replace("NOMBRE_FIRMANTE", nombFirmante)
                    textoFirmante = textoFirmante.Replace("TIPO_DOCUMENTO", dtFirmantesDocumentoContrato.Rows(1)("TIPO_DOCUMENTO").ToString)
                    textoFirmante = textoFirmante.Replace("IDENTIFICADOR", dtFirmantesDocumentoContrato.Rows(1)("NIF").ToString.Trim)
                    textoFirmante = textoFirmante.Replace("CARGO", dtFirmantesDocumentoContrato.Rows(1)("DES_CARGO").ToString.ToUpper(CultureInfoSpain).Trim)
                    textoFirmante = textoFirmante.Replace("NOTARIO", textNotario2)


                    inf.sMasFirmantes2 = textoFirmante

                End If

                DocumentacionRellenaFirmantesQp(inf, dtFirmSPFMDocumentoContrato)

                For Each producto As DataRow In dtProductosDocumentoContrato.Rows

                    Dim canProductos As Integer = 0
                    Dim importeTotal As Decimal = 0
                    Dim importeUnitario As Decimal = 0

                    Decimal.TryParse(producto("CAN_PRODUCTOS").ToString, canProductos)
                    Decimal.TryParse(producto("IMP_PRODUCTO").ToString, importeUnitario)

                    importeTotal = importeUnitario * canProductos

                    Dim actividad As String = producto("DES_PRODUCTO_LIBRE").ToString
                    Dim nProd As String = producto("CAN_PRODUCTOS").ToString
                    Dim nUnid As String = producto("CAN_ENTIDADES_PROD").ToString
                    Dim exentoIva As String = producto("IND_EXENTO_IVA").ToString

                    Dim unidad As String = ""

                    If Not String.IsNullOrEmpty(producto("DES_UNIDAD").ToString) Then
                        unidad = producto("DES_UNIDAD").ToString
                    Else
                        unidad = "Trabajadores"
                    End If

                    Dim precioUnitario As String = importeUnitario.ToString(CultureInfoSpain)
                    Dim total As String = importeTotal.ToString(CultureInfoSpain)

                    inf.ListaActivadesContratacion.Add(New InfoActividadesContratacion() With {.Actividad = actividad, .NProd = nProd, .NUnid = nUnid, .PrecioUnitario = precioUnitario, .Total = total, .Unidad = unidad, .ExentoIva = exentoIva})

                Next

                For Each producto As DataRow In dtProductosDocumentoContrato.Rows

                    Dim actividad As String = producto("DES_PRODUCTO_LIBRE").ToString
                    inf.ListaAAEE.Add(actividad)

                Next

                inf.sFrase = ""
                inf.sMasFirmantes3 = ""

                UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma, inf.NomPersonaFirma, inf.NumFirmantes, ccdCtrDirectivo1)
                If Not String.IsNullOrEmpty(dtFirmSPFMDocumentoContrato.Rows(0)("COD_EMPLEADO2").ToString) Then
                    UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma2, inf.NomPersonaFirma2, inf.NumFirmantes, ccdCtrDirectivo2)
                End If

                If chkGenerarFirmado.Checked Then
                    inf.sIndFirma = "S"
                ElseIf chkGenerarFirmaOtp.Checked Then
                    inf.sIndFirma = "O"
                Else
                    inf.sIndFirma = "N"
                End If

                Dim tienePruebaAbsentismo As Boolean = False

                If dtPruebasExternasDocumentoPresupuesto IsNot Nothing AndAlso dtPruebasExternasDocumentoPresupuesto.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasExternasDocumentoPresupuesto.Rows

                        Dim impTotalPrueba As Decimal
                        impTotalPrueba = pruebaVSI("IMP_UNI_INC") * pruebaVSI("NUM_INCLUIDAS")

                        inf.ListaPruebasExternas.Add(New InfoPruebasExternas() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .PrecioPruebaExterna = pruebaVSI("IMP_UNI_INC").ToString, .numPruebasExternas = pruebaVSI("NUM_INCLUIDAS").ToString, .PrecioTotalPruebaExterna = impTotalPrueba.ToString, .PrecioExcluidoPruebaExterna = pruebaVSI("IMP_UNI_EXC"), .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA")})

                        If pruebaVSI("COD_PRUEBA") = COD_PRUEBA_ABSENTISMOS Then
                            tienePruebaAbsentismo = True
                            If pruebaVSI("IMP_UNI_EXC") > 0 Then
                                inf.IndAbsentismo = True
                                inf.ImporteAbsentismo = pruebaVSI("IMP_UNI_EXC")
                            End If
                        End If
                    Next
                End If

                If Not tienePruebaAbsentismo AndAlso dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA") > 0 Then
                    inf.IndAbsentismo = True
                    inf.ImporteAbsentismo = dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA")
                End If

                If dtPruebasVSI_Reconocimientos IsNot Nothing AndAlso dtPruebasVSI_Reconocimientos.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_Reconocimientos.Rows
                        inf.ListaPruebasExternasReconocimientos.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString, .ImportePruebaExternaRECOBR = pruebaVSI("IMPORTE_RECOBR").ToString})
                    Next
                End If
                If dtPruebasVSI_Analiticas IsNot Nothing AndAlso dtPruebasVSI_Analiticas.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_Analiticas.Rows
                        inf.ListaPruebasExternasAnaliticas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                    Next
                End If
                If dtPruebasVSI_PruebasComplementarias IsNot Nothing AndAlso dtPruebasVSI_PruebasComplementarias.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_PruebasComplementarias.Rows
                        inf.ListaPruebasExternasPruebasComplementarias.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                    Next
                End If
                If dtPruebasVSI_Vacunas IsNot Nothing AndAlso dtPruebasVSI_Vacunas.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_Vacunas.Rows
                        inf.ListaPruebasExternasVacunas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                    Next
                End If

                inf.NomDocumento = "Contrato " & txtCtrCodContrato.Text & ".docx"

                Dim indSepa = rblTipoPago.SelectedValue = "D"
                inf.IndSepa = indSepa

                inf.CrearInforme(PathDocumento.Contrato)

                If indSepa Then
                    Dim infCargoCuenta As New InfOrdenCargoCuentaFirma()
                    AsignarMarcadoresSepa(infCargoCuenta, inf, dtDatosDocumentoContrato.Rows)
                    infCargoCuenta.IndNumAnexo = "III"
                    infCargoCuenta.CrearInforme(PathDocumento.Contrato)
                    inf.Base64 = WordUtil.CombinarDocumentos(inf.Base64, infCargoCuenta.Base64)
                End If

                Dim isPdf As Boolean = False

                If chkGenerarFirmado.Checked OrElse chkGenerarFirmaOtp.Checked Then
                    CambiarCaracteristicasDocumentoAPdf(inf, "Contrato " & txtCtrCodContrato.Text & ".pdf", txtCtrCodContrato.Text, isPdf, inf.Base64)
                End If

                documento = CreateDocument("EXPRESS", inf.Base64, isPdf, UtilidadesSPA.ObtenerTipoFirma(chkGenerarFirmaOtp.Checked, chkGenerarFirmado.Checked))


                If documento <> "" Then
                    Me.AddLoadScript("visualizarDocumentoDigital();")
                End If

                Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
                GetDocuments(detallesContrato)

                For Each producto As DataRow In dtProductosDocumentoContrato.Rows

                    Dim Actividad As String = producto("DES_PRODUCTO_LIBRE").ToString

                    inf.ListaAAEE.Add(Actividad)

                Next
            End If
        End If
    End Sub

    Private Sub GeneraDocumentoContratoAutonomo(ByVal dsDatosDocumentoContrato As DataSet)

        If dsDatosDocumentoContrato.Tables.Count > 0 Then

            Dim dtDatosDocumentoContrato As New DataTable
            Dim dtCentrosDocumentoContrato As New DataTable
            Dim dtProductosDocumentoContrato As New DataTable
            Dim dtFirmantesDocumentoContrato As New DataTable
            Dim dtSumaTrabDocumentoContrato As New DataTable
            Dim dtFirmSPFMDocumentoContrato As New DataTable
            Dim dtPruebasExternasDocumentoPresupuesto As New DataTable

            Dim dtPruebasVSI_Reconocimientos As New DataTable
            Dim dtPruebasVSI_Analiticas As New DataTable
            Dim dtPruebasVSI_PruebasComplementarias As New DataTable
            Dim dtPruebasVSI_Vacunas As New DataTable
            Dim dtFirmanteTerritorial As New DataTable

            dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)
            dtCentrosDocumentoContrato = dsDatosDocumentoContrato.Tables(1)
            dtProductosDocumentoContrato = dsDatosDocumentoContrato.Tables(2)
            dtFirmantesDocumentoContrato = dsDatosDocumentoContrato.Tables(3)
            dtSumaTrabDocumentoContrato = dsDatosDocumentoContrato.Tables(4)
            dtFirmSPFMDocumentoContrato = dsDatosDocumentoContrato.Tables(5)
            dtPruebasExternasDocumentoPresupuesto = dsDatosDocumentoContrato.Tables(9)

            dtPruebasVSI_Reconocimientos = dsDatosDocumentoContrato.Tables(11)
            dtPruebasVSI_Analiticas = dsDatosDocumentoContrato.Tables(12)
            dtPruebasVSI_PruebasComplementarias = dsDatosDocumentoContrato.Tables(13)
            dtPruebasVSI_Vacunas = dsDatosDocumentoContrato.Tables(14)
            dtFirmanteTerritorial = dsDatosDocumentoContrato.Tables(15)

            Dim num_contrato_string As String
            If txtContratoSAP.Text = "" Then
                num_contrato_string = txtCtrCodContrato.Text
            Else
                num_contrato_string = txtContratoSAP.Text
            End If

            Dim inf As New InfContatoAutonomo()

            If dtDatosDocumentoContrato.Rows.Count > 0 Then

                If String.Compare(dtDatosDocumentoContrato.Rows(0)("IND_RENOVABLE").ToString, "S", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                    inf.sIndRenovable = "S"
                    inf.sRenovable = "El presente contrato se pacta por el plazo de un año, prorrogable tácitamente por periodos anuales si ninguna de las partes manifiesta su intención de rescindirlo al menos con un mes de antelación a la fecha del vencimiento."
                End If

                If String.Compare(dtDatosDocumentoContrato.Rows(0)("IND_FACT_ELECTRONICA").ToString, "S", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                    inf.sFactElectronica = "El autónomo acepta que la modalidad de facturación utilizada sea en formato electrónico."
                Else
                    inf.sFactElectronica = ""
                End If
                Dim nomAutonomoPipes As String() = dtDatosDocumentoContrato.Rows(0)("DES_RAZON_SOCIAL").ToString.Trim.Split("|")
                Dim nomAutonomo As String = ""

                If nomAutonomoPipes.Length = 1 Then
                    nomAutonomo = nomAutonomoPipes(0)
                ElseIf nomAutonomoPipes.Length = 2 Then
                    nomAutonomo = String.Concat(nomAutonomoPipes(1), " ", nomAutonomoPipes(0))
                ElseIf nomAutonomoPipes.Length = 3 Then
                    nomAutonomo = String.Concat(nomAutonomoPipes(2), " ", nomAutonomoPipes(0), " ", nomAutonomoPipes(1))
                End If

                inf.sNIF = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString.Trim

                Dim desDireccionSoci As String = ""
                Dim desDomicilioSoci As String = ""
                Dim sTipoViaSoci As String = ""
                Dim sCalleSoci As String = ""
                Dim sNumeroSoci As String = ""
                Dim sPortalSoci As String = ""
                Dim sEscaleraSoci As String = ""
                Dim sPisoSoci As String = ""
                Dim sPuertaSoci As String = ""

                desDireccionSoci = dtDatosDocumentoContrato.Rows(0)("DES_DOMICILIO_SOCI").ToString
                DomicilioDatos.ObtieneDireccion(desDireccionSoci, sTipoViaSoci, sCalleSoci, sNumeroSoci, sPortalSoci, sEscaleraSoci, sPisoSoci, sPuertaSoci)

                desDomicilioSoci = String.Concat(sTipoViaSoci, "/", sCalleSoci, ", ", If(sNumeroSoci <> "", "número " & sNumeroSoci, ""), If(sPortalSoci <> "", " portal " & sPortalSoci, ""), If(sEscaleraSoci <> "", " escalera " & sEscaleraSoci, ""), If(sPisoSoci <> "", " " & sPisoSoci & "º", ""), If(sPuertaSoci <> "", " " & sPuertaSoci, ""))

                Dim fecfirma As Date
                Date.TryParse(dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString, fecfirma)
                inf.sFecha = dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString

                inf.sMes = UtilidadesSPA.GetTextoMes(fecfirma.Month)
                inf.sAnno = fecfirma.Year.ToString(CultureInfoSpain)
                inf.sAutonomo = nomAutonomo

                inf.sNumContrato = num_contrato_string

                inf.sDia = fecfirma.Day.ToString(CultureInfoSpain)
                inf.sDomicilioSocialEmpresa = desDomicilioSoci
                inf.sFecInicio = dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString
                inf.sFecFin = GetFechaFinAutonomo(inf.sFecInicio, inf.sIndRenovable)
                inf.sModoPago = dtDatosDocumentoContrato.Rows(0)("MODO_PAGO").ToString
                inf.sPoblacionEmpresa = dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString
                inf.sPrecio = dtDatosDocumentoContrato.Rows(0)("IMP_TOTAL").ToString
                inf.sProvincia = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString

                If ccdCtrDirectivo1.InfoExtra.Count > 0 Then
                    inf.CodPersonaFirma = ccdCtrDirectivo1.InfoExtra("COD_PERSONA").ToString(CultureInfoSpain).Trim
                End If

                If dtProductosDocumentoContrato IsNot Nothing AndAlso dtProductosDocumentoContrato.Rows.Count > 0 Then
                    For Each producto As DataRow In dtProductosDocumentoContrato.Rows
                        inf.ListaProductos.Add(New InfoProducto() With {.DesProducto = producto("DES_PRODUCTO_LIBRE").ToString, .PrecioProducto = producto("IMP_PRODUCTO").ToString, .NumProductos = producto("CAN_PRODUCTOS").ToString, .PrecioTotalProducto = producto("PRECIO_TOTAL_PRODUCTO").ToString, .ExentoIva = producto("IND_EXENTO_IVA").ToString})
                    Next

                End If

                DocumentacionRellenaFirmantesQp(inf, dtFirmSPFMDocumentoContrato)

                UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma, inf.NomPersonaFirma, inf.NumFirmantes, ccdCtrDirectivo1)
                If Not String.IsNullOrEmpty(dtFirmSPFMDocumentoContrato.Rows(0)("COD_EMPLEADO2").ToString) Then
                    UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma2, inf.NomPersonaFirma2, inf.NumFirmantes, ccdCtrDirectivo2)
                End If

                If chkGenerarFirmado.Checked Then
                    inf.sIndFirma = "S"
                ElseIf chkGenerarFirmaOtp.Checked Then
                    inf.sIndFirma = "O"
                Else
                    inf.sIndFirma = "N"
                End If

                inf.sFechaFutura = dtDatosDocumentoContrato.Rows(0)("FEC_INICIO_FACT").ToString

                If inf.sFechaFutura <> "" Then
                    inf.sIndFechaFutura = "S"
                Else
                    inf.sIndFechaFutura = "N"
                End If

                inf.sPeriodoFactura = dtDatosDocumentoContrato.Rows(0)("PERIODO_FACTURA").ToString
                inf.sPlazoVencimiento = dtDatosDocumentoContrato.Rows(0)("IND_PLAZO_VENC").ToString
                inf.sModoPago = dtDatosDocumentoContrato.Rows(0)("MODO_PAGO").ToString
                inf.sTribunal = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString

                Dim tienePruebaAbsentismo As Boolean = False

                If dtPruebasExternasDocumentoPresupuesto IsNot Nothing AndAlso dtPruebasExternasDocumentoPresupuesto.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasExternasDocumentoPresupuesto.Rows

                        Dim impTotalPrueba As Decimal
                        impTotalPrueba = pruebaVSI("IMP_UNI_INC") * pruebaVSI("NUM_INCLUIDAS")

                        inf.ListaPruebasExternas.Add(New InfoPruebasExternas() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .PrecioPruebaExterna = pruebaVSI("IMP_UNI_INC").ToString, .numPruebasExternas = pruebaVSI("NUM_INCLUIDAS").ToString, .PrecioTotalPruebaExterna = impTotalPrueba.ToString, .PrecioExcluidoPruebaExterna = pruebaVSI("IMP_UNI_EXC"), .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA")})

                        If pruebaVSI("COD_PRUEBA") = COD_PRUEBA_ABSENTISMOS Then
                            tienePruebaAbsentismo = True
                            If pruebaVSI("IMP_UNI_EXC") > 0 Then
                                inf.IndAbsentismo = True
                                inf.ImporteAbsentismo = pruebaVSI("IMP_UNI_EXC")
                            End If
                        End If
                    Next
                End If

                If Not tienePruebaAbsentismo AndAlso dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA") > 0 Then
                    inf.IndAbsentismo = True
                    inf.ImporteAbsentismo = dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA")
                End If

                If dtPruebasVSI_Reconocimientos IsNot Nothing AndAlso dtPruebasVSI_Reconocimientos.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_Reconocimientos.Rows
                        inf.ListaPruebasExternasReconocimientos.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString, .ImportePruebaExternaRECOBR = pruebaVSI("IMPORTE_RECOBR").ToString})
                    Next
                End If
                If dtPruebasVSI_Analiticas IsNot Nothing AndAlso dtPruebasVSI_Analiticas.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_Analiticas.Rows
                        inf.ListaPruebasExternasAnaliticas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                    Next
                End If
                If dtPruebasVSI_PruebasComplementarias IsNot Nothing AndAlso dtPruebasVSI_PruebasComplementarias.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_PruebasComplementarias.Rows
                        inf.ListaPruebasExternasPruebasComplementarias.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                    Next
                End If
                If dtPruebasVSI_Vacunas IsNot Nothing AndAlso dtPruebasVSI_Vacunas.Rows.Count > 0 Then
                    For Each pruebaVSI As DataRow In dtPruebasVSI_Vacunas.Rows
                        inf.ListaPruebasExternasVacunas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                    Next
                End If

                inf.NomDocumento = "Contrato " & txtCodContrato.Text & ".docx"

                Dim indSepa = rblTipoPago.SelectedValue = "D"
                inf.IndSepa = indSepa

                inf.CrearInforme(PathDocumento.Contrato)

                If indSepa Then
                    Dim infCargoCuenta As New InfOrdenCargoCuentaFirma()
                    AsignarMarcadoresSepa(infCargoCuenta, inf, dtDatosDocumentoContrato.Rows)
                    infCargoCuenta.IndNumAnexo = "I"
                    infCargoCuenta.CrearInforme(PathDocumento.Contrato)
                    inf.Base64 = WordUtil.CombinarDocumentos(inf.Base64, infCargoCuenta.Base64)
                End If

                Dim isPdf As Boolean = False

                If chkGenerarFirmado.Checked OrElse chkGenerarFirmaOtp.Checked Then
                    CambiarCaracteristicasDocumentoAPdf(inf, "Contrato " & txtCtrCodContrato.Text & ".pdf", txtCtrCodContrato.Text, isPdf, inf.Base64)
                End If

                Dim documento As String = CreateDocument("AUTONOMO", inf.Base64, isPdf, UtilidadesSPA.ObtenerTipoFirma(chkGenerarFirmaOtp.Checked, chkGenerarFirmado.Checked))

                If documento <> "" Then
                    Me.AddLoadScript("visualizarDocumentoDigital();")
                End If

                Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
                GetDocuments(detallesContrato)

            End If
        End If

    End Sub

    Private Sub GeneraDocumentoContratoBolsaHoras(ByVal dsDatosDocumentoContrato As DataSet)

        If dsDatosDocumentoContrato.Tables.Count > 0 Then

            Dim dtDatosDocumentoContrato As New DataTable
            Dim dtCentrosDocumentoContrato As New DataTable
            Dim dtProductosDocumentoContrato As New DataTable
            Dim dtFirmantesDocumentoContrato As New DataTable
            Dim dtSumaTrabDocumentoContrato As New DataTable
            Dim dtFirmSPFMDocumentoContrato As New DataTable
            Dim dtPruebasExternasDocumentoPresupuesto As New DataTable

            Dim dtPruebasVSI_Reconocimientos As New DataTable
            Dim dtPruebasVSI_Analiticas As New DataTable
            Dim dtPruebasVSI_PruebasComplementarias As New DataTable
            Dim dtPruebasVSI_Vacunas As New DataTable
            Dim dtFirmanteTerritorial As New DataTable

            dtDatosDocumentoContrato = dsDatosDocumentoContrato.Tables(0)
            dtCentrosDocumentoContrato = dsDatosDocumentoContrato.Tables(1)
            dtProductosDocumentoContrato = dsDatosDocumentoContrato.Tables(2)
            dtFirmantesDocumentoContrato = dsDatosDocumentoContrato.Tables(3)
            dtSumaTrabDocumentoContrato = dsDatosDocumentoContrato.Tables(4)
            dtFirmSPFMDocumentoContrato = dsDatosDocumentoContrato.Tables(5)
            dtPruebasExternasDocumentoPresupuesto = dsDatosDocumentoContrato.Tables(9)

            dtPruebasVSI_Reconocimientos = dsDatosDocumentoContrato.Tables(11)
            dtPruebasVSI_Analiticas = dsDatosDocumentoContrato.Tables(12)
            dtPruebasVSI_PruebasComplementarias = dsDatosDocumentoContrato.Tables(13)
            dtPruebasVSI_Vacunas = dsDatosDocumentoContrato.Tables(14)
            dtFirmanteTerritorial = dsDatosDocumentoContrato.Tables(15)

            Dim num_contrato_string As String
            If txtContratoSAP.Text = "" Then
                num_contrato_string = txtCtrCodContrato.Text
            Else
                num_contrato_string = txtContratoSAP.Text
            End If

            Dim inf As New InfContratoBolsaDeHoras()

            inf.sNumContrato = num_contrato_string

            If dtDatosDocumentoContrato.Rows.Count > 0 Then

                inf.sLocalidad = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                inf.sTribunal = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString
                inf.sFecha = dtDatosDocumentoContrato.Rows(0)("FEC_FIRMA").ToString

                Dim nomEmpresaPipes As String() = dtDatosDocumentoContrato.Rows(0)("DES_RAZON_SOCIAL").ToString.Trim.Split("|")
                Dim nomEmpresa As String = ""

                If nomEmpresaPipes.Length = 1 Then
                    nomEmpresa = nomEmpresaPipes(0).ToString
                ElseIf nomEmpresaPipes.Length = 2 Then
                    nomEmpresa = String.Concat(nomEmpresaPipes(1), " ", nomEmpresaPipes(0))
                ElseIf nomEmpresaPipes.Length = 3 Then
                    nomEmpresa = String.Concat(nomEmpresaPipes(2), " ", nomEmpresaPipes(0), " ", nomEmpresaPipes(1))
                End If

                inf.sEmpresa = nomEmpresa
                inf.sRazonSocial = nomEmpresa

                inf.sCIFEmpresa = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString
                inf.sNIFFirmanteEmpresa = dtDatosDocumentoContrato.Rows(0)("COD_IDENTIFICADOR").ToString

                Dim desDireccionSoci As String = ""
                Dim desDomicilioSoci As String = ""
                Dim sTipoViaSoci As String = ""
                Dim sCalleSoci As String = ""
                Dim sNumeroSoci As String = ""
                Dim sPortalSoci As String = ""
                Dim sEscaleraSoci As String = ""
                Dim sPisoSoci As String = ""
                Dim sPuertaSoci As String = ""

                desDireccionSoci = dtDatosDocumentoContrato.Rows(0)("DES_DOMICILIO_SOCI").ToString
                DomicilioDatos.ObtieneDireccion(desDireccionSoci, sTipoViaSoci, sCalleSoci, sNumeroSoci, sPortalSoci, sEscaleraSoci, sPisoSoci, sPuertaSoci)

                desDomicilioSoci = String.Concat(sTipoViaSoci, "/", sCalleSoci, ", ", If(sNumeroSoci <> "", "número " & sNumeroSoci, ""), If(sPortalSoci <> "", " portal " & sPortalSoci, ""), If(sEscaleraSoci <> "", " escalera " & sEscaleraSoci, ""), If(sPisoSoci <> "", " " & sPisoSoci & "º", ""), If(sPuertaSoci <> "", " " & sPuertaSoci, ""))

                inf.sDomicilioSocialEmpresa = desDomicilioSoci
                inf.sCodigoPostalEmpresa = UtilidadesSPA.CompletarCodigoPostal(dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI"))
                inf.sPoblacionEmpresa = dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString
                inf.sProvincia = dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString

                'ASG 20151223 Añado la provincia a la dirección del cliente.
                desDomicilioSoci = String.Concat(desDomicilioSoci, ", ", dtDatosDocumentoContrato.Rows(0)("COD_POSTAL_SOCI").ToString, ", ", dtDatosDocumentoContrato.Rows(0)("DES_POBLACION_SOCI").ToString, " (", dtDatosDocumentoContrato.Rows(0)("DES_PROVINCIA_SOCI").ToString, ")")

                inf.sDireccion = desDomicilioSoci

                inf.sCodCNAE = dtDatosDocumentoContrato.Rows(0)("COD_ACTIVIDAD").ToString
                inf.sDesCNAE = dtDatosDocumentoContrato.Rows(0)("DES_ACTIVIDAD").ToString


                inf.sImporteRecoAP = dtDatosDocumentoContrato.Rows(0)("IMP_RECO_ALTA_PEL").ToString
                inf.sImporteRecoBP = dtDatosDocumentoContrato.Rows(0)("IMP_RECO_BAJA_PEL").ToString
                inf.sEurSHE = dtDatosDocumentoContrato.Rows(0)("IMP_PROD_SHE").ToString
                inf.sEurMT = dtDatosDocumentoContrato.Rows(0)("IMP_PROD_MT").ToString
                inf.sEurTotal = dtDatosDocumentoContrato.Rows(0)("IMP_TOTAL_PRODUCTOS").ToString

                inf.sPeriodoFactura = dtDatosDocumentoContrato.Rows(0)("PERIODO_FACTURA").ToString
                inf.sPlazoVencimiento = dtDatosDocumentoContrato.Rows(0)("IND_PLAZO_VENC").ToString
                inf.sModoPago = dtDatosDocumentoContrato.Rows(0)("MODO_PAGO").ToString

                Dim iIncluye As Integer = 0

                Integer.TryParse(dtDatosDocumentoContrato.Rows(0)("CAN_MIN_TRAB_RECO").ToString, iIncluye)

                If iIncluye > 0 Then
                    inf.sIncluye = "El importe reflejado en el apartado de Medicina del Trabajo - Vigilancia de la Salud incluye la realización de " & iIncluye.ToString & " reconocimiento médico."
                Else
                    inf.sIncluye = ""
                End If

                inf.sFechaFutura = dtDatosDocumentoContrato.Rows(0)("FEC_INICIO_FACT").ToString

                If inf.sFechaFutura <> "" Then
                    inf.sIndFechaFutura = "S"
                Else
                    inf.sIndFechaFutura = "N"
                End If

                inf.sIndRenovable = dtDatosDocumentoContrato.Rows(0)("IND_RENOVABLE").ToString.Trim
            End If

            inf.sNumTrabEmpresa = dtSumaTrabDocumentoContrato.Rows(0)("SUM_TRAB_TOTAL").ToString

            If dtCentrosDocumentoContrato IsNot Nothing AndAlso dtCentrosDocumentoContrato.Rows.Count > 0 Then
                inf.ListaCentrosTrabajo.AddRange(RellenarCentrosTrabajo(dtCentrosDocumentoContrato))
            End If

            If dtFirmantesDocumentoContrato.Rows.Count > 0 Then

                If dtFirmantesDocumentoContrato.Rows.Count = 1 Then

                    Dim nomFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")

                    If nomFirmantePipes.Length = 1 Then
                        inf.sFirmanteEmpresa = nomFirmantePipes(0)
                    ElseIf nomFirmantePipes.Length = 2 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
                    ElseIf nomFirmantePipes.Length = 3 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
                    End If

                    inf.sTipoDoc = dtFirmantesDocumentoContrato.Rows(0)("TIPO_DOCUMENTO").ToString
                    inf.sNIF = dtFirmantesDocumentoContrato.Rows(0)("NIF").ToString.Trim
                    inf.sCargo1 = String.Concat(" en calidad de ", dtFirmantesDocumentoContrato.Rows(0)("DES_CARGO").ToString.ToUpper(CultureInfoSpain))

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString) Then
                        inf.sNotario = dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        Dim textNotario As String = TEXTO_NOTARIO

                        textNotario = textNotario.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(0)("FEC_NOTARIO1").ToString)
                        textNotario = textNotario.Replace("PODER", dtFirmantesDocumentoContrato.Rows(0)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString) Then
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString)
                        Else
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("POBLACION").ToString)
                        End If

                        textNotario = textNotario.Replace("NOM_NOTARIO", nomNotario)

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            inf.sNotario = ""
                        Else
                            inf.sNotario = textNotario
                        End If

                    End If

                    inf.sMasFirmantes2 = ""
                    inf.sMasFirmantes3 = ""

                End If

                If dtFirmantesDocumentoContrato.Rows.Count = 2 Then

                    Dim nomFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_CONTACTO").ToString.ToUpper(CultureInfoSpain).Split("|")

                    If nomFirmantePipes.Length = 1 Then
                        inf.sFirmanteEmpresa = nomFirmantePipes(0)
                    ElseIf nomFirmantePipes.Length = 2 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
                    ElseIf nomFirmantePipes.Length = 3 Then
                        inf.sFirmanteEmpresa = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
                    End If

                    inf.sTipoDoc = dtFirmantesDocumentoContrato.Rows(0)("TIPO_DOCUMENTO").ToString
                    inf.sNIF = dtFirmantesDocumentoContrato.Rows(0)("NIF").ToString.Trim
                    inf.sCargo1 = String.Concat(" en calidad de ", dtFirmantesDocumentoContrato.Rows(0)("DES_CARGO").ToString.ToUpper(CultureInfoSpain).Trim)

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString) Then
                        inf.sNotario = dtFirmantesDocumentoContrato.Rows(0)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(0)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        Dim textNotario As String = TEXTO_NOTARIO

                        textNotario = textNotario.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(0)("FEC_NOTARIO1").ToString)
                        textNotario = textNotario.Replace("PODER", dtFirmantesDocumentoContrato.Rows(0)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString) Then
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("PROVINCIA").ToString)
                        Else
                            textNotario = textNotario.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(0)("POBLACION").ToString)
                        End If

                        textNotario = textNotario.Replace("NOM_NOTARIO", nomNotario)

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            inf.sNotario = ""
                        Else
                            inf.sNotario = textNotario
                        End If

                    End If


                    Dim textoFirmante As String = TEXTO_FIRMANTE
                    Dim textNotario2 As String = TEXTO_NOTARIO

                    If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(1)("DES_NOTARIO").ToString) Then
                        textNotario2 = dtFirmantesDocumentoContrato.Rows(1)("DES_NOTARIO").ToString
                    Else

                        Dim nomNotarioPipes As String() = dtFirmantesDocumentoContrato.Rows(1)("NOM_NOTARIO").ToString.Split("|")
                        Dim nomNotario As String = ""

                        If nomNotarioPipes.Length = 1 Then
                            nomNotario = nomNotarioPipes(0)
                        ElseIf nomNotarioPipes.Length = 2 Then
                            nomNotario = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
                        ElseIf nomNotarioPipes.Length = 3 Then
                            nomNotario = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
                        End If

                        textNotario2 = textNotario2.Replace("FECHA", dtFirmantesDocumentoContrato.Rows(1)("FEC_NOTARIO1").ToString)
                        textNotario2 = textNotario2.Replace("PODER", dtFirmantesDocumentoContrato.Rows(1)("NUM_PROTOCOLO").ToString)

                        If Not String.IsNullOrEmpty(dtFirmantesDocumentoContrato.Rows(1)("PROVINCIA").ToString) Then
                            textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(1)("PROVINCIA").ToString)
                        Else
                            textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", dtFirmantesDocumentoContrato.Rows(1)("POBLACION").ToString)
                        End If

                        If String.Compare(nomNotario, "", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                            textNotario2 = ""
                        Else
                            textNotario2 = textNotario2.Replace("NOM_NOTARIO", nomNotario)
                        End If

                    End If

                    Dim nombFirmantePipes As String() = dtFirmantesDocumentoContrato.Rows(1)("NOM_CONTACTO").ToString.ToUpper.Split("|")
                    Dim nombFirmante As String = ""

                    If nombFirmantePipes.Length = 1 Then
                        nombFirmante = nombFirmantePipes(0)
                    ElseIf nombFirmantePipes.Length = 2 Then
                        nombFirmante = String.Concat(nombFirmantePipes(1), " ", nombFirmantePipes(0))
                    ElseIf nombFirmantePipes.Length = 3 Then
                        nombFirmante = String.Concat(nombFirmantePipes(2), " ", nombFirmantePipes(0), " ", nombFirmantePipes(1))
                    End If

                    textoFirmante = textoFirmante.Replace("NOMBRE_FIRMANTE", nombFirmante)
                    textoFirmante = textoFirmante.Replace("TIPO_DOCUMENTO", dtFirmantesDocumentoContrato.Rows(1)("TIPO_DOCUMENTO").ToString)
                    textoFirmante = textoFirmante.Replace("IDENTIFICADOR", dtFirmantesDocumentoContrato.Rows(1)("NIF").ToString.Trim)
                    textoFirmante = textoFirmante.Replace("CARGO", dtFirmantesDocumentoContrato.Rows(1)("DES_CARGO").ToString.ToUpper(CultureInfoSpain).Trim)
                    textoFirmante = textoFirmante.Replace("NOTARIO", textNotario2)


                    inf.sMasFirmantes2 = textoFirmante
                    inf.sMasFirmantes3 = ""

                End If
            End If

            DocumentacionRellenaFirmantesQp(inf, dtFirmSPFMDocumentoContrato)

            For Each producto As DataRow In dtProductosDocumentoContrato.Rows

                Dim canProductos As Integer = 0
                Dim importeTotal As Decimal = 0
                Dim importeUnitario As Decimal = 0

                Decimal.TryParse(producto("CAN_PRODUCTOS").ToString, canProductos)
                Decimal.TryParse(producto("IMP_PRODUCTO").ToString, importeUnitario)

                importeTotal = importeUnitario * canProductos

                Dim actividad As String = producto("DES_PRODUCTO_LIBRE").ToString
                Dim nprod As String = producto("CAN_PRODUCTOS").ToString
                Dim nUnid As String = producto("CAN_ENTIDADES_PROD").ToString
                Dim exentoIva As String = producto("IND_EXENTO_IVA").ToString

                Dim unidad As String = ""

                If Not String.IsNullOrEmpty(producto("DES_UNIDAD").ToString) Then
                    unidad = producto("DES_UNIDAD").ToString
                Else
                    unidad = "Trabajadores"
                End If

                Dim precioUnitario As String = importeUnitario.ToString(CultureInfoSpain)
                Dim total As String = importeTotal.ToString(CultureInfoSpain)

                inf.ListaActivadesContratacion.Add(New InfoActividadesContratacion() With {.Actividad = actividad, .NProd = nprod, .NUnid = nUnid, .PrecioUnitario = precioUnitario, .Total = total, .Unidad = unidad, .ExentoIva = exentoIva})
            Next

            For Each producto As DataRow In dtProductosDocumentoContrato.Rows

                Dim Actividad As String = producto("DES_PRODUCTO_LIBRE").ToString
                inf.ListaAAEE.Add(Actividad)

            Next

            inf.sFrase = ""

            If ccdCtrDirectivo1.InfoExtra.Count > 0 Then
                inf.CodPersonaFirma = ccdCtrDirectivo1.InfoExtra("COD_PERSONA").ToString.Trim
            End If

            UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma, inf.NomPersonaFirma, inf.NumFirmantes, ccdCtrDirectivo1)
            If Not String.IsNullOrEmpty(dtFirmSPFMDocumentoContrato.Rows(0)("COD_EMPLEADO2").ToString) Then
                UtilidadesSPA.ObtenerFirmante(inf.CodPersonaFirma2, inf.NomPersonaFirma2, inf.NumFirmantes, ccdCtrDirectivo2)
            End If

            If chkGenerarFirmado.Checked Then
                inf.sIndFirma = "S"
            ElseIf chkGenerarFirmaOtp.Checked Then
                inf.sIndFirma = "O"
            Else
                inf.sIndFirma = "N"
            End If

            Dim tienePruebaAbsentismo As Boolean = False

            If dtPruebasExternasDocumentoPresupuesto IsNot Nothing AndAlso dtPruebasExternasDocumentoPresupuesto.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasExternasDocumentoPresupuesto.Rows

                    Dim impTotalPrueba As Decimal
                    impTotalPrueba = pruebaVSI("IMP_UNI_INC") * pruebaVSI("NUM_INCLUIDAS")

                    inf.ListaPruebasExternas.Add(New InfoPruebasExternas() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .PrecioPruebaExterna = pruebaVSI("IMP_UNI_INC").ToString, .numPruebasExternas = pruebaVSI("NUM_INCLUIDAS").ToString, .PrecioTotalPruebaExterna = impTotalPrueba.ToString, .PrecioExcluidoPruebaExterna = pruebaVSI("IMP_UNI_EXC"), .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA")})

                    If pruebaVSI("COD_PRUEBA") = COD_PRUEBA_ABSENTISMOS Then
                        tienePruebaAbsentismo = True
                        If pruebaVSI("IMP_UNI_EXC") > 0 Then
                            inf.IndAbsentismo = True
                            inf.ImporteAbsentismo = pruebaVSI("IMP_UNI_EXC")
                        End If
                    End If
                Next
            End If

            If Not tienePruebaAbsentismo AndAlso dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA") > 0 Then
                inf.IndAbsentismo = True
                inf.ImporteAbsentismo = dtDatosDocumentoContrato.Rows(0)("IMP_PRUEBA")
            End If

            If dtPruebasVSI_Reconocimientos IsNot Nothing AndAlso dtPruebasVSI_Reconocimientos.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_Reconocimientos.Rows
                    inf.ListaPruebasExternasReconocimientos.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString, .ImportePruebaExternaRECOBR = pruebaVSI("IMPORTE_RECOBR").ToString})
                Next
            End If
            If dtPruebasVSI_Analiticas IsNot Nothing AndAlso dtPruebasVSI_Analiticas.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_Analiticas.Rows
                    inf.ListaPruebasExternasAnaliticas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                Next
            End If
            If dtPruebasVSI_PruebasComplementarias IsNot Nothing AndAlso dtPruebasVSI_PruebasComplementarias.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_PruebasComplementarias.Rows
                    inf.ListaPruebasExternasPruebasComplementarias.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                Next
            End If
            If dtPruebasVSI_Vacunas IsNot Nothing AndAlso dtPruebasVSI_Vacunas.Rows.Count > 0 Then
                For Each pruebaVSI As DataRow In dtPruebasVSI_Vacunas.Rows
                    inf.ListaPruebasExternasVacunas.Add(New InfoPruebasExternas_Tramos() With {.DesPruebaExterna = pruebaVSI("DES_PRUEBA").ToString, .ImportePruebaExterna = pruebaVSI("IMPORTE").ToString, .numDesdePruebasExternas = pruebaVSI("DESDE").ToString, .numHastaPruebasExternas = pruebaVSI("HASTA").ToString, .TipoPruebaExterna = pruebaVSI("IND_TIPO_PRUEBA").ToString})
                Next
            End If

            inf.NomDocumento = "Contrato " & txtCodContrato.Text & ".docx"

            Dim indSepa = rblTipoPago.SelectedValue = "D"
            inf.IndSepa = indSepa

            inf.CrearInforme(PathDocumento.Contrato)

            If indSepa Then
                Dim infCargoCuenta As New InfOrdenCargoCuentaFirma()
                AsignarMarcadoresSepa(infCargoCuenta, inf, dtDatosDocumentoContrato.Rows)
                infCargoCuenta.IndNumAnexo = "III"
                infCargoCuenta.CrearInforme(PathDocumento.Contrato)
                inf.Base64 = WordUtil.CombinarDocumentos(inf.Base64, infCargoCuenta.Base64)
            End If

            Dim isPdf As Boolean = False

            If chkGenerarFirmado.Checked OrElse chkGenerarFirmaOtp.Checked Then
                CambiarCaracteristicasDocumentoAPdf(inf, "Contrato " & txtCtrCodContrato.Text & ".pdf", txtCtrCodContrato.Text, isPdf, inf.Base64)
            End If

            Dim documento As String = CreateDocument("BOLSA_HORAS", inf.Base64, isPdf, UtilidadesSPA.ObtenerTipoFirma(chkGenerarFirmaOtp.Checked, chkGenerarFirmado.Checked))

            If documento <> "" Then
                Me.AddLoadScript("visualizarDocumentoDigital();")
            End If

            Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
            GetDocuments(detallesContrato)

        End If
    End Sub

    Private Sub btnMuestraDocumentoContratoDigital_Click(sender As Object, e As EventArgs) Handles btnMuestraDocumentoContratoDigital.Click

        Dim documentsWebServiceAjax As DocumentsWebServiceAjax = New DocumentsWebServiceAjax()
        Dim documento As Documento

        If Not String.IsNullOrEmpty(hfIdDocumentoVisualizacionContrato.Value) Then
            documento = documentsWebServiceAjax.GetContractDocument(txtCtrIdContrato.Text, hfIdDocumentoVisualizacionContrato.Value, -1)
        Else
            documento = documentsWebServiceAjax.GetLastDocument(txtCtrIdContrato.Text, DOCUMENTO_CONTRATO)
        End If

        If documento IsNot Nothing Then
            MostrarDocumento(documento)
        End If

    End Sub

    Private Function descomprimirDataset(b As [Byte]()) As DataSet
        Try

            Dim ds As New DataSet()
            Dim dt As New DataTable

            Using ms As New MemoryStream(b)

                Using zip As New GZipStream(ms, CompressionMode.Decompress)
                    ds.ReadXml(zip, System.Data.XmlReadMode.Auto)
                    zip.Close()
                End Using

                ms.Close()

            End Using

            If ds Is Nothing Then
                ds.Tables.Add(dt.Copy())
            Else
                If ds.Tables.Count = 0 Then
                    ds.Tables.Add(dt.Copy())
                End If
            End If

            Return ds
        Catch ex As Exception
            Dim ds As New DataSet()
            Dim dt As New DataTable
            ds.Tables.Add(dt.Copy())
            Return ds
        End Try
    End Function

    Private Sub compruebaPrivilegiosTarifa()

        Try

            Dim dtTarifas As New DataTable

            dtTarifas = Session("Tarifas")

            Dim dtTarif As New DataTable

            dtTarif = dtTarifas

            Dim columnaIdTarifa(1) As DataColumn
            columnaIdTarifa(0) = dtTarif.Columns("ID_TIP_TARIF")
            dtTarif.PrimaryKey = columnaIdTarifa


            Dim sIdTarifa As String = ""

            If ccdTarifaModalidad.InfoExtra.Count > 0 Then
                If ccdTarifaModalidad.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                    sIdTarifa = ccdTarifaModalidad.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim()
                End If
            ElseIf ccdTarifaProductos.InfoExtra.Count > 0 Then
                If ccdTarifaProductos.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                    sIdTarifa = ccdTarifaProductos.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim()
                End If
            ElseIf ccdTarifaBolsaHoras.InfoExtra.Count > 0 Then
                If ccdTarifaBolsaHoras.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                    sIdTarifa = ccdTarifaBolsaHoras.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim()
                End If
            ElseIf ccdTarifaAutonomos.InfoExtra.Count > 0 Then
                If ccdTarifaAutonomos.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim <> "" Then
                    sIdTarifa = ccdTarifaAutonomos.InfoExtra("ID_TIP_TARIF").ToString(CultureInfoSpain).Trim()

                End If
            End If


            hdnPermisoPerfilTarifa.Value = "N"

            If (sIdTarifa <> "") AndAlso (dtTarif.Rows.Find(sIdTarifa) IsNot Nothing) Then
                Dim tarifRow As DataRow = dtTarif.NewRow
                tarifRow = dtTarif.Rows.Find(sIdTarifa)

                Dim IND_CENTRAL As String = tarifRow("IND_CENTRAL").ToString.Trim()
                Dim IND_ADMIN As String = tarifRow("IND_ADMIN").ToString.Trim()
                Dim IND_DIRPROV As String = tarifRow("IND_DIRPROV").ToString.Trim()
                Dim IND_DIRTER As String = tarifRow("IND_DIRTER").ToString.Trim()
                Dim IND_DIROFI As String = tarifRow("IND_DIROFI").ToString.Trim()

                If (String.Compare(cacheContratacion.hfEsPerfilCentral.Value, "S", StringComparison.InvariantCultureIgnoreCase) = 0) Then
                    hdnPermisoPerfilTarifa.Value = IND_CENTRAL
                ElseIf (String.Compare(cacheContratacion.hfEsPerfilDirProvincial.Value, "S", StringComparison.InvariantCultureIgnoreCase) = 0) Then
                    hdnPermisoPerfilTarifa.Value = IND_DIRPROV
                ElseIf (String.Compare(cacheContratacion.hfEsPerfilDirTerritorial.Value, "S", StringComparison.InvariantCultureIgnoreCase) = 0) Then
                    hdnPermisoPerfilTarifa.Value = IND_DIRTER
                ElseIf (String.Compare(cacheContratacion.hfEsPerfilDirOficina.Value, "S", StringComparison.InvariantCultureIgnoreCase) = 0) Then
                    hdnPermisoPerfilTarifa.Value = IND_DIROFI
                Else
                    hdnPermisoPerfilTarifa.Value = IND_ADMIN
                End If
            End If

            If (String.Compare(hdnPermisoPerfilTarifa.Value, "N", StringComparison.InvariantCultureIgnoreCase) = 0) Then
                MostrarMensaje("No tiene privilegios para grabar Presupuestos de ésta Tarifa.")
            End If

        Catch ex As Exception

        End Try

    End Sub

    Private Function Ipc1(COD_CONTRATO As Long) As Integer

        Dim VALOR As Integer
        Dim Resu As String

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[sDelAnexoIPC]")

        Try

            db.AddInParameter(dbCommand, "COD_CONTRATO", DbType.Int64, COD_CONTRATO)

            db.AddOutParameter(dbCommand, "VALOR", DbType.Int64, 0)
            db.AddOutParameter(dbCommand, "result", DbType.String, 300)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 300)

            db.ExecuteNonQuery(dbCommand)

            Resu = db.GetParameterValue(dbCommand, "result")

            VALOR = db.GetParameterValue(dbCommand, "VALOR")

            Return VALOR


        Catch ex As Exception

        End Try

    End Function

    Private Sub DelIPC(COD_CONTRATO As Long, ipcFijo As String, USUA As String)

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand

        dbCommand = db.GetStoredProcCommand("[SPA].[DelAnexoIPC]")

        db.AddInParameter(dbCommand, "COD_CONTRATO", DbType.Int64, COD_CONTRATO)
        db.AddInParameter(dbCommand, "IPC_FIJO", DbType.String, ipcFijo)
        db.AddInParameter(dbCommand, "NOM_USUARIO_ULTMOD", DbType.String, USUA)

        db.AddOutParameter(dbCommand, "result", DbType.Int32, 0)
        db.AddOutParameter(dbCommand, "sError", DbType.String, 8000)

        db.ExecuteNonQueryApplicationInsights(dbCommand, tc)

    End Sub

    Private Sub btnBajaMultiple_Click(sender As Object, e As EventArgs) Handles btnBajaMultiple.Click

        Dim Lstcontratos As String
        Dim Arrcontratos As String()
        Dim Ncomas As Integer
        Dim Narrarycontratos As Integer
        Dim FECHA As Date
        Dim sFecha As String

        Lstcontratos = txtCtrBajaMultiple.Text
        Ncomas = Lstcontratos.Split("|").Length - 2
        Arrcontratos = Lstcontratos.Split("|")
        Narrarycontratos = Arrcontratos.Length
        Dim sMes As String
        Dim sDia As String
        Dim sAnnyo As String
        Dim Nerrores As Integer

        FECHA = calCtrFecBaja2.Fecha

        If FECHA <> Nothing AndAlso txtCtrObservBaja2.Text <> "" AndAlso ddlCtrCausaBaja2.SelectedValue > 0 Then

            sAnnyo = FECHA.Year.ToString(CultureInfoSpain)

            If FECHA.Month < 10 Then
                sMes = "0" & FECHA.Month.ToString(CultureInfoSpain)
            Else
                sMes = FECHA.Month.ToString(CultureInfoSpain)
            End If
            If FECHA.Day < 10 Then
                sDia = "0" & FECHA.Day.ToString(CultureInfoSpain)
            Else
                sDia = +FECHA.Day.ToString(CultureInfoSpain)
            End If



            sFecha = sAnnyo & sMes & sDia

            If Ncomas = Narrarycontratos - 2 Then
                For i = 0 To Narrarycontratos - 2

                    Nerrores = BajaMultipleAAEE(Arrcontratos(i), sFecha, txtCtrObservBaja2.Text, ddlCtrCausaBaja2.SelectedValue, Usuario.Login)

                Next

            Else
                'lanzamos un alert
                Me.AddLoadScript("mError();")
            End If

        Else
            Me.AddLoadScript("mError2();")

        End If

        If Nerrores > 0 Then
            Me.AddLoadScript("mError3();")
        End If


    End Sub

    Private Function BajaMultipleAAEE(cod_contrato As Int64, fec_terminado As String,
                                      DES_OBSER As String, CAUSABAJA As Integer, USUA As String) As Integer
        Dim VALOR As Integer

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[bMContratosAAEE]")

        Try

            db.AddInParameter(dbCommand, "COD_CONTRATO", DbType.Int64, cod_contrato)
            db.AddInParameter(dbCommand, "FEC_TERMINADO", DbType.String, fec_terminado)
            db.AddInParameter(dbCommand, "DES_OBSERV_BAJA", DbType.String, DES_OBSER)
            db.AddInParameter(dbCommand, "CAUSABAJA", DbType.Int32, CAUSABAJA)
            db.AddInParameter(dbCommand, "USUARIO", DbType.String, USUA)

            db.AddOutParameter(dbCommand, "result", DbType.Int32, 0)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 8000)

            db.ExecuteNonQuery(dbCommand)

            VALOR = db.GetParameterValue(dbCommand, "result")

            Return VALOR

        Catch ex As Exception

        End Try

    End Function

    Private Sub btnVerActividades_Click(sender As Object, e As EventArgs) Handles btnVerActividades.Click

    End Sub

    Public Function dameTiposObserv(ByVal sNomLog As String) As DataTable

        Dim result As Boolean
        Dim serror As String

        Try

            Dim dttiposobs As New DataTable

            Dim db As New GestorBD("NEGOCIO")
            Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[STiposObservaciones]")

            db.AddOutParameter(dbCommand, "result", DbType.Boolean, 1)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 1)

            dttiposobs = (db.ExecuteDataSet(dbCommand)).Tables(0)

            serror = CStr(db.GetParameterValue(dbCommand, "sError"))
            result = CBool(db.GetParameterValue(dbCommand, "result"))

            If Not result Then
                Throw New RfnException(serror)
            End If

            Return dttiposobs

        Catch ex As Exception

            Return Nothing
        End Try

    End Function

    Private Sub ddlobser_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlobser.SelectedIndexChanged

    End Sub

    Private Sub CargarObservacionesIniciales()
        If txtContratoSAP.Text <> "" Then

            Dim dtobs As DataTable
            Dim TextoObservaciones As String = ""
            dtobs = CargarObservaciones(txtCtrCodContrato.Text, -1)

            If dtobs IsNot Nothing Then

                For Each row As DataRow In dtobs.Rows
                    If dtobs.Rows.Count = 1 Then
                        TextoObservaciones = CStr(row("DES_OBSERVACIONES"))
                    Else
                        TextoObservaciones = TextoObservaciones & CStr(row("DES_OBSERVACIONES")) & vbCrLf
                    End If
                Next

                txtCtrObserv.Text = TextoObservaciones.ToString

            End If
        Else

            panelobser.Style.Add("display", "none")

        End If
    End Sub

    Public Function CargarObservaciones(contrato As Double, tipo As Integer) As DataTable

        Dim result As Boolean
        Dim serror As String

        Try

            Dim dtobservaciones As New DataTable

            Dim db As New GestorBD("NEGOCIO")
            Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[SObservaciones_READ]")

            db.AddInParameter(dbCommand, "Contrato", DbType.Double, contrato)
            db.AddInParameter(dbCommand, "TIPO", DbType.Int32, tipo)
            db.AddOutParameter(dbCommand, "result", DbType.Boolean, 1)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 1)

            dtobservaciones = (db.ExecuteDataSet(dbCommand)).Tables(0)

            serror = CStr(db.GetParameterValue(dbCommand, "sError"))
            result = CBool(db.GetParameterValue(dbCommand, "result"))

            If Not result Then
                Throw New RfnException(serror)
            End If

            Return dtobservaciones

        Catch ex As Exception

            Return Nothing
        End Try

    End Function

    Private Sub btnVerObervaciones_Click(sender As Object, e As EventArgs) Handles btnVerObervaciones.Click

        Dim dtobser As DataTable
        txtCtrObserv.Text = ""

        dtobser = CargarObservaciones(txtCtrCodContrato.Text, CInt(ddlobser.SelectedValue))
        For Each row As DataRow In dtobser.Rows
            txtCtrObserv.Text = CStr(row("DES_OBSERVACIONES")) & vbCrLf
        Next

    End Sub

    Private Function DameTarifaCont(COD_CONTRATO As Long) As Integer

        Dim VALOR As Integer
        Dim Resu As String

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[DameTarifaContrato]")

        Try

            db.AddInParameter(dbCommand, "CONTRATO", DbType.Int64, COD_CONTRATO)

            db.AddOutParameter(dbCommand, "TARIFA", DbType.Int64, 1)
            db.AddOutParameter(dbCommand, "result", DbType.String, 300)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 300)
            db.ExecuteNonQuery(dbCommand)

            Resu = db.GetParameterValue(dbCommand, "result")

            VALOR = db.GetParameterValue(dbCommand, "TARIFA")

            Return VALOR

        Catch ex As Exception

        End Try

    End Function

    Private Sub btnValFace_Click(sender As Object, e As EventArgs) Handles btnValFace.Click

    End Sub

    Public Sub RELOAD()
        Dim param As ParametrosPaginaBase = New ParametrosPaginaBase

        param("idContrato") = Parametro("idContrato")
        param("codContrato") = Parametro("codContrato")
        param("idCliente") = Parametro("idCliente")
        param("indEstadoContrato") = Parametro("indEstadoContrato")
        param("contratoSAP") = Parametro("contratoSAP")
        param("indEspecificas") = Parametro("indEspecificas")
        param("indAutonomo") = Parametro("indAutonomo")
        param("indBolsaHoras") = Parametro("indBolsaHoras")
        param("tarifa") = Parametro("tarifa")

        NavegarPagina("VSPA01003", param)
    End Sub

    Private Sub btnTerminadoToVigente_Click(sender As Object, e As EventArgs) Handles btnTerminadoToVigente.Click
        RELOAD()
    End Sub

    Private Function ValidaUsuarioRIPC(NOM_LOGIN As String) As Integer

        Dim VALOR As Integer

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[VALUSUARIORIPC]")


        Try

            db.AddInParameter(dbCommand, "NOM_LOGIN", DbType.String, NOM_LOGIN)
            db.AddOutParameter(dbCommand, "VALOR", DbType.Int64, 0)
            db.ExecuteNonQuery(dbCommand)

            VALOR = db.GetParameterValue(dbCommand, "VALOR")

            Return VALOR


        Catch ex As Exception

        End Try

    End Function

    Public Function DamePerfilesUsuario(login As String) As Integer

        Dim VALOR As Integer

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[DamePerfilesFacturacion]")

        Try

            db.AddInParameter(dbCommand, "@LOGIN", DbType.String, login)
            db.AddOutParameter(dbCommand, "@RESULT", DbType.Int64, 0)
            db.ExecuteNonQuery(dbCommand)

            VALOR = db.GetParameterValue(dbCommand, "@RESULT")

            Return VALOR

        Catch ex As Exception

        End Try
    End Function

    Public Function DamePerfilesUsuarioRegAnexo(login As String) As Integer

        Dim VALOR As Integer

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[DamePerfilesFacturacionReguAnexos]")

        Try

            db.AddInParameter(dbCommand, "@LOGIN", DbType.String, login)
            db.AddOutParameter(dbCommand, "@RESULT", DbType.Int64, 0)
            db.ExecuteNonQuery(dbCommand)

            VALOR = db.GetParameterValue(dbCommand, "@RESULT")

            Return VALOR

        Catch ex As Exception

        End Try
    End Function

    Public Function PermisoContraBayes(login As String) As Boolean
        Dim VALOR As Integer

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[SPermisoCBUsu]")

        Try

            db.AddInParameter(dbCommand, "NOM_LOGIN", DbType.String, login)
            db.AddOutParameter(dbCommand, "VALOR", DbType.Int64, 0)
            db.ExecuteNonQuery(dbCommand)
            VALOR = db.GetParameterValue(dbCommand, "VALOR")

            If VALOR > 0 Then
                Return True
            Else
                Return False
            End If

        Catch ex As Exception

        End Try
    End Function

    Public Function UltimoAnexoContrato(idContrato As Integer) As DataTable

        Dim result As Boolean
        Dim serror As String

        Try
            Dim dtAnexo As New DataTable

            Dim db As New GestorBD("NEGOCIO")
            Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[UltimoAnexoContrato]")

            If idContrato > 0 Then
                db.AddInParameter(dbCommand, "ID_CONTRATO", DbType.Int32, idContrato)
            End If

            db.AddOutParameter(dbCommand, "result", DbType.Boolean, 1)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 1)

            dtAnexo = (db.ExecuteDataSet(dbCommand)).Tables(0)

            serror = CStr(db.GetParameterValue(dbCommand, "sError"))
            result = CBool(db.GetParameterValue(dbCommand, "result"))

            If Not result Then
                Throw New RfnException(serror)
            End If

            Return dtAnexo

        Catch ex As Exception
            Return Nothing
        End Try
    End Function


    Public Function ContratoTramosRMBaja(idContrato As Integer, codAnexo As Integer) As Boolean
        Dim VALOR As Integer

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[ContratoTramosRM]")

        Try
            If idContrato > 0 Then
                db.AddInParameter(dbCommand, "ID_CONTRATO", DbType.Int32, idContrato)
            End If

            If codAnexo > 400000 Then
                db.AddInParameter(dbCommand, "COD_ULT_ANEX", DbType.Int32, codAnexo)
            End If

            db.AddOutParameter(dbCommand, "result", DbType.Boolean, 1)
            db.AddOutParameter(dbCommand, "sError", DbType.String, 1)
            db.AddOutParameter(dbCommand, "rr", DbType.Int32, 1)

            db.ExecuteNonQuery(dbCommand)

            VALOR = db.GetParameterValue(dbCommand, "rr").ToString

            If VALOR > 0 Then
                Return True
            Else
                Return False
            End If

        Catch ex As Exception

        End Try

    End Function

    Public Function PermisoFuncionalidad(login As String, funcionalidad As String) As String

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[SPermisoFUNC]")

        db.AddInParameter(dbCommand, "NOM_LOGIN", DbType.String, login)
        db.AddInParameter(dbCommand, "FUNC", DbType.String, funcionalidad)

        db.AddOutParameter(dbCommand, "VALOR", DbType.Int64, 0)

        db.ExecuteNonQueryApplicationInsights(dbCommand, tc)
        Dim result As Integer = db.GetParameterValueApplicationInsights("VALOR", dbCommand, tc)

        If result > 0 Then
            Return "S"
        Else
            Return "N"
        End If

    End Function

    Protected Function GuardaDatos(sender As Object, e As System.EventArgs) Handles btnmodificacentro.Click

        Try

            Dim resultado As Integer = 0

            Dim wsContratacion As New WsContratacion.WsContratacion

            Dim dsCentro As New DataSet
            Dim dtCentro As New DataTable

            dtCentro.Columns.Add("ID_CLIENTE")
            dtCentro.Columns.Add("ID_CENTRO")
            dtCentro.Columns.Add("ID_POBLACION")
            dtCentro.Columns.Add("COD_POSTAL")
            dtCentro.Columns.Add("DES_REFERENCIA")
            dtCentro.Columns.Add("DES_DOMICILIO")
            dtCentro.Columns.Add("ID_REGION")
            dtCentro.Columns.Add("NUM_TELEFONO")
            dtCentro.Columns.Add("NUM_FAX")
            dtCentro.Columns.Add("IND_PRIMER_CENTRO")
            dtCentro.Columns.Add("COD_HISTORICO")



            Dim drCentro As DataRow = dtCentro.NewRow()

            drCentro("ID_CLIENTE") = hfidCliente.Value

            drCentro("ID_CENTRO") = hfIdCentroDireccion.Value

            Dim sDesDireccion As String = ""

            sDesDireccion = GenerarDireccionCentro(Me.cmbTipoVia.SelectedValue, Me.txtCalle.Text.Trim, Me.txtNum.Text.Trim, Me.txtPortal.Text.Trim, Me.txtEscalera.Text.Trim, Me.txtPiso.Text.Trim, Me.txtPuerta.Text.Trim)

            drCentro("COD_POSTAL") = cmbCodPostal.SelectedValue
            drCentro("DES_REFERENCIA") = txtReferenciaDomi.Text.Trim
            drCentro("DES_DOMICILIO") = sDesDireccion


            drCentro("ID_REGION") = Me.cmbProvincia.SelectedValue
            drCentro("ID_POBLACION") = ccdPoblacion.Codigo
            drCentro("NUM_TELEFONO") = Me.txtTelefono.Text.Trim
            drCentro("NUM_FAX") = Me.txtFax.Text.Trim

            drCentro("IND_PRIMER_CENTRO") = MetodosAux.CheckAString(chkPrimerCentro)

            drCentro("COD_HISTORICO") = hfIdCentroHist.Value

            dtCentro.Rows.Add(drCentro)

            dsCentro.Tables.Add(dtCentro.Copy())

            resultado = wsContratacion.GuardaCentroContrato(dsCentro.Tables(0), Usuario.Login, txtCtrCodContrato.Text)

            If resultado <> -1 Then
                hfIdCentro.Value = resultado
                Me.MostrarMensaje("Se ha grabado el Centro de Trabajo correctamente", TEXTO_INFORMACION)
                Me.AddLoadScript("filtroCT();")
                Return True
            Else
                Me.MostrarMensaje("Error al grabar el Centro de Trabajo", TEXTO_ERROR)
                Return False
            End If

        Catch ex As Exception
            Me.MostrarMensaje("Error al grabar el Centro de Trabajo." & ex.ToString, TEXTO_ERROR)
            Throw
        End Try

    End Function


    Private Function GenerarDireccionCentro(ByVal CodTipoVia As String, ByVal Calle As String, ByVal Numero As String, ByVal Portal As String, ByVal Escalera As String, ByVal Piso As String, ByVal Puerta As String) As String
        Dim cadena As String
        cadena = String.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}", CodTipoVia, Calle, Numero, Portal, Escalera, Piso, Puerta)
        Return cadena
    End Function

    Public Function EsPreupuestoQS(Cod_Contrato As Integer) As String

        Dim db As New GestorBD("NEGOCIO")
        Dim dbCommand As Common.DbCommand = db.GetStoredProcCommand("[SPA].[SpresupuestoQS]")

        Try

            db.AddInParameter(dbCommand, "CODCONTRATO", DbType.Int32, Cod_Contrato)
            db.AddOutParameter(dbCommand, "FILIAL", DbType.Int32, 1)
            db.ExecuteNonQuery(dbCommand)

            Return db.GetParameterValue(dbCommand, "FILIAL").ToString

        Catch ex As Exception

            Return ""
        End Try


    End Function

    Protected Sub btnDescargarExcelAux_Click(sender As Object, e As System.EventArgs) Handles btnDescargarExcelAux.Click
        InfExcel()
        grupoCentrosTrabajo.Collapsed = False
    End Sub
    Private Sub InfExcel()
        Dim xlApp As B.SpreadsheetDocument

        Dim filename As String = ""
        If (rblTipoExcel.SelectedIndex = 0) Then
            If txtNombreCompleto.Text <> "" Then
                filename = "Centros_De_Trabajo_Anexo_Contrato_" & txtCtrCodContrato.Text & "_Cliente_" & txtIdentificador.Text & ".xlsm"
            Else
                filename = "Centros_De_Trabajo_Contrato_" & txtCtrCodContrato.Text & "_Cliente_" & txtIdentificador.Text & ".xlsm"
            End If

        ElseIf (rblTipoExcel.SelectedIndex = 1) Then
            filename = "Centros_De_Trabajo_Contrato_" & txtCtrCodContrato.Text & ".xlsm"
        Else
            filename = "Centros_De_Trabajo_En_Contrato_Cliente_" & txtIdentificador.Text & ".xlsm"
        End If

        Dim carpetaSesion As String = ConfArq.Instance.RutaTemp
        Dim pathFile As String = carpetaSesion & "\" & filename

        Dim length As Integer
        Dim dataToRead As Long
        Dim iStream As System.IO.FileStream = Nothing
        Dim buffer As Byte() = New [Byte](99999) {}


        Try
            If Not (Directory.Exists(carpetaSesion)) Then
                Directory.CreateDirectory(carpetaSesion)
            End If

            Dim rutaPlantilla As String = AppConfiguration.GetKeyValue(AppConfigurationKeys.PathRaizPlantillas) & "\CentrosTrabajo"

            Dim sNombreCompleto As String
            If txtNombreCompleto.Text <> "" Then
                sNombreCompleto = txtNombreCompleto.Text.Trim.ToUpper(CultureInfoSpain)
            Else
                sNombreCompleto = String.Concat(txtApellido1.Text.Trim.ToUpper(CultureInfoSpain), "_", txtApellido2.Text.Trim.ToUpper(CultureInfoSpain), "_", txtNombre.Text.Trim.ToUpper(CultureInfoSpain))
            End If

            File.Copy(rutaPlantilla & "\Gestion_Masiva_Centros_De_Trabajo_Anexo.xlsm", pathFile)
            xlApp = clsExcelContratacion.mete_fila_anexo(pathFile, 0, CInt(txtCtrIdContrato.Text), CInt(txtCtrCodContrato.Text), 0, CInt(hfidCliente.Value), rblTipoExcel.SelectedIndex)

            Response.Clear()

            If xlApp IsNot Nothing Then
                xlApp = Nothing
                GC.Collect()
                GC.WaitForPendingFinalizers()
                GC.Collect()
                GC.WaitForPendingFinalizers()
            End If

            Dim info As FileInfo = New FileInfo(pathFile)
            iStream = New System.IO.FileStream(pathFile, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read)
            Response.Clear()
            Response.ClearContent()
            Response.ClearHeaders()
            Response.ContentType = "application/vnd.ms-excel"
            Response.ContentEncoding = Encoding.GetEncoding(CODIFICACION_EXCEL)
            Response.AddHeader("Content-Disposition", "attachment; filename=" & info.Name)

            dataToRead = iStream.Length
            While dataToRead > 0
                If Response.IsClientConnected Then
                    length = iStream.Read(buffer, 0, 100000)
                    Response.OutputStream.Write(buffer, 0, length)
                    buffer = New [Byte](99999) {}
                    dataToRead = dataToRead - length
                Else
                    dataToRead = -1
                End If
            End While

            If iStream IsNot Nothing Then
                iStream.Close()
            End If

            Response.Flush()
            Response.End()

            Try
                If File.Exists(pathFile) Then
                    Response.Clear()
                    File.Delete(pathFile)
                End If

                If Directory.Exists(carpetaSesion) Then
                    Response.Clear()
                    Directory.Delete(carpetaSesion)
                End If
            Catch ex As Exception
                tc.TrackException(ex)
            End Try
            Me.AddLoadScript("ocultarModal()")

            Return
        Catch ex As Exception
            tc.TrackException(ex)
            MostrarMensaje(ex.ToString, "Error al generar el documento")

        End Try

    End Sub

    Private Sub CargaPlazoPagoTebex()

        cmbPlazoPago.Items.Clear()

        Dim pago0 As New ListItem
        Dim pago7 As New ListItem
        Dim pago15 As New ListItem
        Dim pago30 As New ListItem

        pago0.Value = "1"
        pago0.Text = "0"

        pago7.Value = "2"
        pago7.Text = "7"

        pago15.Value = "4"
        pago15.Text = "15"

        pago30.Value = "3"
        pago30.Text = "30"

        cmbPlazoPago.Items.Add(pago0)
        cmbPlazoPago.Items.Add(pago7)
        cmbPlazoPago.Items.Add(pago15)
        cmbPlazoPago.Items.Add(pago30)

    End Sub

    Private Function ConstruirEmailTexbex(sCodContrato As String, sEmailCaptador As String) As Boolean

        Try
            Dim ws As ClientesWebServiceAjax = New ClientesWebServiceAjax()
            Dim Email As New List(Of String)
            Dim subject As String = ""
            Dim body As String = ""
            Dim CC As New List(Of String)
            Dim BCC As New List(Of String)
            Dim attachments As New Dictionary(Of String, String)

            subject = avisoContratacion.EMAIL_SUBJECT_TEBEX
            body = avisoContratacion.EMAIL_BODY_TEBEX

            subject = subject.Replace(ConstantesContratacion.COD_CONTRATO, sCodContrato)

            Email.Add(AppConfiguration.GetKeyValue(AppConfigurationKeys.EmailTebex))

            If (sEmailCaptador <> "") Then
                CC.Add(sEmailCaptador)
            End If

            Return ws.EnviarEmail(Email, body, subject, CC, BCC, "1100", attachments, 0, True)

        Catch ex As Exception
            Me.MostrarMensaje("Se ha producido un error al enviar el email: " & ex.ToString, TEXTO_ERROR)
        End Try

    End Function

    Private Function ConstruirEmailQPPortugal(sCodContrato As String, sEmpresa As String, sEmailCaptador As String) As Boolean

        Try
            Dim ws As ClientesWebServiceAjax = New ClientesWebServiceAjax()
            Dim Email As New List(Of String)
            Dim subject As String = ""
            Dim body As String = ""
            Dim CC As New List(Of String)
            Dim BCC As New List(Of String)
            Dim attachments As New Dictionary(Of String, String)

            subject = avisoContratacion.EMAIL_SUBJECT_QPPORTUGAL
            body = avisoContratacion.EMAIL_BODY_QPPORTUGAL

            subject = subject.Replace(ConstantesContratacion.COD_CONTRATO, sCodContrato)

            body = body.Replace(ConstantesContratacion.COD_CONTRATO, sCodContrato)
            body = body.Replace(ConstantesContratacion.NOMBRE_EMPRESA, sEmpresa)

            Email.Add(AppConfiguration.GetKeyValue(AppConfigurationKeys.EmailQPPortugal))

            If (sEmailCaptador <> "") Then
                CC.Add(sEmailCaptador)
            End If

            Return ws.EnviarEmail(Email, body, subject, CC, BCC, "1100", attachments, 0, True)

        Catch ex As Exception
            Me.MostrarMensaje("Se ha producido un error al enviar el email: " & ex.ToString, TEXTO_ERROR)
        End Try

    End Function

    Private Function ConstruirEmailQPPeru(sCodContrato As String, sEmpresa As String, sEmailCaptador As String) As Boolean

        Try
            Dim ws As ClientesWebServiceAjax = New ClientesWebServiceAjax()
            Dim Email As New List(Of String)
            Dim subject As String = ""
            Dim body As String = ""
            Dim CC As New List(Of String)
            Dim BCC As New List(Of String)
            Dim attachments As New Dictionary(Of String, String)

            subject = avisoContratacion.EMAIL_SUBJECT_QPPERU
            body = avisoContratacion.EMAIL_BODY_QPPERU

            subject = subject.Replace(ConstantesContratacion.COD_CONTRATO, sCodContrato)

            body = body.Replace(ConstantesContratacion.COD_CONTRATO, sCodContrato)
            body = body.Replace(ConstantesContratacion.NOMBRE_EMPRESA, sEmpresa)

            Email.Add(AppConfiguration.GetKeyValue(AppConfigurationKeys.EmailQPPeru))

            If (sEmailCaptador <> "") Then
                CC.Add(sEmailCaptador)
            End If

            Return ws.EnviarEmail(Email, body, subject, CC, BCC, "1100", attachments, 0, True)

        Catch ex As Exception
            Me.MostrarMensaje("Se ha producido un error al enviar el email: " & ex.ToString, TEXTO_ERROR)
        End Try
    End Function

    Private Function ValidaCodContratoVigente() As Boolean

        Dim contratoDatos As DataRow = Comun.Datos.ContratoDatos.CargaContrato(Nothing, txtCtrContratoNuevo.Text.Trim(), tc)
        Dim indEstado As String = contratoDatos("IND_ESTADO").ToString.Trim

        If indEstado = "-" Then
            Me.AddLoadScript("RequerirContratoNuevo();")
            MostrarMensaje(TEXTO_CONTRATO_NOT_FOUND, TEXTO_ERROR)
            Return False
        ElseIf indEstado <> "V" Then
            Me.AddLoadScript("RequerirContratoNuevo();")
            MostrarMensaje(TEXTO_CONTRATO_NOT_VALIDO, TEXTO_ERROR)
            Return False
        End If

        Return True

    End Function

    Private Function ValidarEmails(emails As String) As Boolean

        emails = emails.Replace(",", ";").Replace(" ", ";")

        For Each direccion As String In emails.Split(";")
            If Not String.IsNullOrEmpty(direccion) AndAlso Not ValidarEmail(direccion.Trim()) Then
                Return False
            End If
        Next

        If emails.Length > 255 Then
            Return False
        End If

        Return True

    End Function

    Private Function ValidarEmail(ByVal email As String) As Boolean
        Return Regex.IsMatch(email, "^[a-zA-Z0-9üñ_\-+]+(\.[a-zA-Z0-9üñ_\-]+)*@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9üñ\-]+\.)+))([a-zA-Züñ]{2,20}|[0-9]{1,3})(\]?)$", RegexOptions.Compiled)
    End Function

    Private Sub btnGrabaDomiSocial_Click(sender As Object, e As System.EventArgs) Handles btnGrabaDomiSocial.Click
        Try
            Dim dsSocial As New DataSet
            Dim dtSocial As New DataTable
            Dim direccion As String = ""

            direccion = DomicilioDatos.GeneraDireccion(cmbTipoViaDS.SelectedValue, txtCalleDS.Text.Trim, txtNumDS.Text.Trim, txtPortalDS.Text.Trim, txtEscaleraDS.Text.Trim, txtPisoDS.Text.Trim, txtPuertaDS.Text.Trim)

            dtSocial.Columns.Add("ID_CLIENTE")
            dtSocial.Columns.Add("ID_CONTRATO")
            dtSocial.Columns.Add("ID_DOMI_SOCIAL")
            dtSocial.Columns.Add("DES_RAZON_SOCIAL")
            dtSocial.Columns.Add("DES_DOMICILIO")
            dtSocial.Columns.Add("COD_POSTAL")
            dtSocial.Columns.Add("ID_POBLACION")
            dtSocial.Columns.Add("ID_REGION")
            dtSocial.Columns.Add("NUM_TELEFONO")
            dtSocial.Columns.Add("NUM_FAX")
            dtSocial.Columns.Add("CENTRAL")

            Dim drSocial As DataRow = dtSocial.NewRow()

            drSocial("ID_CLIENTE") = hfidCliente.Value
            drSocial("ID_CONTRATO") = txtCtrIdContrato.Text
            drSocial("ID_DOMI_SOCIAL") = hfIdDomiSocial.Value


            If Not String.IsNullOrEmpty(txtAltaNombreCompletoSocial.Text) Then
                drSocial("DES_RAZON_SOCIAL") = txtAltaNombreCompletoSocial.Text.Trim.ToUpper(CultureInfoSpain)
            Else

                Dim nombre As String = ""
                Dim apellido1 As String = ""
                Dim apellido2 As String = ""

                nombre = txtAltaNombreSocial.Text.Trim.ToUpper(CultureInfoSpain)
                apellido1 = txtAltaApellido1Social.Text.Trim.ToUpper(CultureInfoSpain)
                apellido2 = txtAltaApellido2Social.Text.Trim.ToUpper(CultureInfoSpain)

                drSocial("DES_RAZON_SOCIAL") = (String.Concat(apellido1, "|", apellido2, "|", nombre)).ToString(CultureInfoSpain)

            End If

            drSocial("CENTRAL") = "S"
            drSocial("DES_DOMICILIO") = direccion
            drSocial("COD_POSTAL") = txtCPDS.Text.Trim
            drSocial("ID_POBLACION") = ccdPoblacionDS.Codigo
            drSocial("ID_REGION") = cmbProvinciaDS.SelectedValue
            drSocial("NUM_TELEFONO") = txtTelefonoDS.Text.Trim
            drSocial("NUM_FAX") = txtNumFaxDS.Text.Trim

            If Not String.IsNullOrEmpty(txtEmailDS.Text) AndAlso Not ValidarEmail(txtEmailDS.Text.Trim) Then
                Me.MostrarMensaje("No se ha modificado el Contrato, el Email cliente no es válido.", TEXTO_ERROR)
                Return
            End If

            dtSocial.Rows.Add(drSocial)

            dsSocial.Tables.Add(dtSocial)

            Dim wsContratacion As New WsContratacion.WsContratacion

            Dim a As Integer

            a = wsContratacion.GuardadatosSocialesContrato(dsSocial.Tables(0), Usuario.Login)

            Me.AddLoadScript("ActualizaDatosContrato();")

        Catch ex As Exception
            Me.MostrarMensaje("Error al modificar los datos sociales del Contrato" & ex.ToString, TEXTO_ERROR)
        End Try

        hfTelefonoDS.Value = txtTelefonoDS.Text.Trim
        hfFaxDS.Value = txtTelefonoDS.Text.Trim
        hfEmailDS.Value = txtEmailDS.Text.Trim
    End Sub

    Private Sub btnSubeDocumento_Click(sender As Object, e As System.EventArgs) Handles btnSubeDocumento.Click

        Try
            Dim nombreArchivo As String = ""
            If Not fuDocumento.HasFile Then Return
            nombreArchivo = fuDocumento.FileName

            Dim path As String = UtilidadesSPA.GetPath(PathDocumento.Generados)

            Dim extension As String = MetodosAux.ObtenerExtensionFichero(nombreArchivo)
            If Not extension.Contains("pdf") Then
                chkWebSubeDocumento.Checked = False
            End If

            Dim success = UploadDocument(UtilidadesSPA.QuitarCaracteresEspeciales(nombreArchivo), path, chkWebSubeDocumento.Checked)

            Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
            GetDocuments(detallesContrato)

            If success Then
                Me.MostrarMensaje("Se ha guardado el documento correctamente.", TEXTO_INFORMACION)
                chkWebSubeDocumento.Checked = False
            End If
        Catch ex As Exception
            Traces.TrackException(ex, tc, pageName, "Error al subir el documento")
        End Try
    End Sub

    Private Sub EliminarDocumento(codigoFichero As String)
        Dim documentsWebServiceAjax As New DocumentsWebServiceAjax()
        Dim datosDigital As List(Of DocumentoContrato) = documentsWebServiceAjax.GetContractDocuments(CInt(txtCtrIdContrato.Text))

        If datosDigital.Count > 0 Then
            For Each documento As DocumentoContrato In datosDigital
                If Not documento.FileName.Contains("Cargo") Then
                    calCtrFecGeneracion.Fecha = documento.CreateDate
                    If documento.DocumentId = codigoFichero Then
                        If cacheContratacion.hfEsPerfilCentral.Value = "S" OrElse documento.User.ToUpper(CultureInfo.InvariantCulture) = Usuario.Login.ToUpper(CultureInfo.InvariantCulture) Then
                            AddLoadScript("EliminarDocumentoContrato(" & documento.ContractId & ", '" & documento.DocumentId & "', '" & documento.User & "');")
                        Else
                            MostrarMensaje("El docuemento no puede ser eliminado ya que el usuario que lo subió no es el mismo que esta conectado.", TEXTO_INFORMACION)
                        End If
                    End If
                End If
            Next
        End If
        documentsWebServiceAjax.Dispose()
    End Sub

    Private Sub FirmarDocumento(codigoFichero As String, nombreFichero As String)
        If (ddlCtrEstadoContrato.SelectedValue <> "P") Then
            MostrarMensaje("El contrato debe estar en estado Pendiente.", TEXTO_INFORMACION)
        ElseIf Not (nombreFichero.Substring(nombreFichero.Length - 4, 4).Equals(".pdf", System.StringComparison.CurrentCultureIgnoreCase) OrElse
            nombreFichero.Substring(nombreFichero.Length - 4, 4).Equals(".doc", System.StringComparison.CurrentCultureIgnoreCase) OrElse
            nombreFichero.Substring(nombreFichero.Length - 5, 5).Equals(".docx", System.StringComparison.CurrentCultureIgnoreCase)) Then
            MostrarMensaje("Sólo se pueden firmar documentos tipo Word o PDF.", TEXTO_INFORMACION)
        ElseIf (txtCtrEmailRepresentante1.Text = "" AndAlso hfautonomo.Value <> "S") OrElse (hfautonomo.Value = "S" AndAlso txtEmailDS.Text = "") Then
            MostrarMensaje("El email del representante por parte del cliente debe estar informado.", TEXTO_INFORMACION)
        Else
            Using contratosWebServiceAjax As New ContratosWebServiceAjax()
                Try
                    Traces.TrackTrace(tc, pageName, SeverityLevel.Information, "Llamamos a firmar documento")
                    Traces.TrackDependency(tc, pageName, "FirmaOTP vb", "Llamamos a firmar documento")
                    Me.AddLoadScript("FirmarDocumentoContrato(" & CInt(txtCtrIdContrato.Text) & ", '" & codigoFichero & "', '" & nombreFichero & "', '" & Usuario.Login.ToUpper(CultureInfo.InvariantCulture) & "');")
                    Traces.TrackTrace(tc, pageName, SeverityLevel.Information, "Después de llamar a firmar documento")
                    Traces.TrackDependency(tc, pageName, "FirmaOTP vb", "Después de llamar a firmar documento --> ")
                Catch ex As Exception
                    Traces.TrackException(ex, tc, pageName, "Error al firmar documento")
                End Try

            End Using
        End If
    End Sub

    Private Sub CancelarDocumento(codigoFichero As String, nombreFichero As String)
        Me.AddLoadScript("CancelarDocumentoContrato(" & CInt(txtCtrIdContrato.Text) & ", '" & codigoFichero & "', '" & nombreFichero & "', '" & Usuario.Login.ToUpper(CultureInfo.InvariantCulture) & "');")
    End Sub

    Private Sub DescargarDocumento(codigoFichero As String, documentVersion As Integer)

        Dim documento As Documento

        Using documentsWebServiceAjax As New DocumentsWebServiceAjax()
            documento = documentsWebServiceAjax.GetContractDocument(CInt(txtCtrIdContrato.Text), codigoFichero, documentVersion)
        End Using

        If documento.fileName = "Not found" Then
            MostrarMensaje(TEXTO_NOT_FOUND)
        Else
            MostrarDocumento(documento)
        End If

    End Sub

    Private Sub gvCtrDatosFicherosDigital_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvCtrDatosFicherosDigital.RowCommand
        Dim argumentos As String() = e.CommandArgument.ToString.Split(",")
        If e.CommandName = "Eliminar" Then
            EliminarDocumento(argumentos(0))
        ElseIf e.CommandName = "Firma" Then
            FirmarDocumento(argumentos(0), argumentos(1))
        ElseIf e.CommandName = "Cancelar" Then
            CancelarDocumento(argumentos(0), argumentos(1))
        ElseIf e.CommandName = "DescargarDocumento" Then
            If argumentos(0) <> "GedoDocument" Then
                argumentos(2) = -1
            End If
            DescargarDocumento(argumentos(0), argumentos(2))
        End If
    End Sub

    Private Sub MostrarDocumento(documento As Documento)
        If documento IsNot Nothing Then
            Try
                Dim binarydata As Byte() = Convert.FromBase64String(documento.base64StringFile)
                Using memoryStream As New MemoryStream(binarydata)
                    Response.Clear()
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                    Response.AppendHeader("content-disposition", "attachment; filename=" & documento.fileName)
                    memoryStream.WriteTo(Response.OutputStream)
                    Response.End()
                End Using
            Catch exth As System.Threading.ThreadAbortException
                'Expected
            Catch ex As Exception
                Traces.TrackException(ex, tc, pageName, "Error en MostrarDocumento()")
            End Try
        End If
    End Sub

    Private Sub btnreload_Click(sender As Object, e As EventArgs) Handles btnreload.Click
        Dim param As ParametrosPaginaBase = New ParametrosPaginaBase

        param("idContrato") = Parametro("idContrato")
        param("codContrato") = Parametro("codContrato")
        param("idCliente") = Parametro("idCliente")
        param("indEstadoContrato") = Parametro("indEstadoContrato")
        param("contratoSAP") = Parametro("contratoSAP")
        param("indEspecificas") = Parametro("indEspecificas")
        param("indAutonomo") = Parametro("indAutonomo")
        param("indBolsaHoras") = Parametro("indBolsaHoras")
        param("tarifa") = Parametro("tarifa")

        NavegarPagina("VSPA01003", param)
    End Sub


    Private Sub btnCargaDocumentos_Click(sender As Object, e As EventArgs) Handles btnCargaDocumentos.Click
        Dim detallesContrato As DetallesContrato = GetDetallesContrato(CInt(txtCtrCodContrato.Text))
        GetDocuments(detallesContrato)
    End Sub

    Public Sub GetDocuments(detallesContrato As DetallesContrato)
        Dim datosUnificados As List(Of DocumentoContrato)
        datosUnificados = ComprobarFirmaDigitalContrato(detallesContrato)
        If datosUnificados IsNot Nothing AndAlso datosUnificados.Count > 0 Then
            Dim UltimoDocumento As DocumentoContrato
            UltimoDocumento = datosUnificados.Find(Function(x) Not x.FileName.Contains("Cargo"))
            If UltimoDocumento IsNot Nothing Then
                calCtrFecGeneracion.Fecha = UltimoDocumento.CreateDate
                txtCtrVersionDocumento.Text = "V.0_" & UltimoDocumento.Version
                txtCtrVersionDocumento.Attributes.Add("onmouseover", "this.style.cursor='pointer'; this.style.fontWeight='bold';")
                txtCtrVersionDocumento.Attributes.Add("onmouseout", "this.style.fontWeight='';")
                txtCtrVersionDocumento.Attributes.Add("onclick", "histCtrDocumento();")
            Else
                calCtrFecGeneracion.Fecha = Date.MinValue
                txtCtrVersionDocumento.Text = String.Empty
                txtCtrVersionDocumento.Attributes.Remove("onmouseover")
                txtCtrVersionDocumento.Attributes.Remove("onmouseout")
                txtCtrVersionDocumento.Attributes.Remove("onclick")
            End If

            gvCtrDatosFicherosDigital.Columns(4).Visible = True
            gvCtrDatosFicherosDigital.DataSource = datosUnificados
            gvCtrDatosFicherosDigital.DataBind()
        Else
            calCtrFecGeneracion.Fecha = Date.MinValue
            txtCtrVersionDocumento.Text = String.Empty
        End If
    End Sub

    Public Function CreateDocument(tipoContrato As String, base64 As String, isPdf As Boolean, tipofirma As String) As String
        Dim archivo As String = ""
        Dim resultBase As TResultBase(Of DocumentoCreado)

        Dim documento As DocumentoApi = New DocumentoApi() With {
             .Id = CInt(txtCtrIdContrato.Text),
             .Cif = ccdRazonSocial.Codigo,
             .NombreDocumento = "",
             .TipoContrato = tipoContrato,
             .DocumentoBase64 = base64,
             .Usuario = Usuario.Login,
             .Codigo = CInt(txtCtrCodContrato.Text),
             .IsPdf = isPdf,
             .TipoFirma = tipofirma,
             .Web = False
        }

        Using documentsWebServiceAjax As New DocumentsWebServiceAjax()
            resultBase = documentsWebServiceAjax.CreateContractDocument(documento)
            If resultBase.isSuccess Then
                If resultBase.result IsNot Nothing Then
                    hfIdDocumentoVisualizacion.Value = resultBase.result.Id
                    archivo = resultBase.result.Filename
                End If
            Else
                MostrarMensaje(resultBase.message, TEXTO_ERROR)
            End If
        End Using

        Return archivo
    End Function

    Public Function UploadDocument(nomDocumento As String, path As String, web As Boolean) As Boolean
        Dim documento = path & "\" & nomDocumento
        fuDocumento.SaveAs(documento)
        If documento = "" Then
            Return False
        End If

        Dim binarydata As Byte() = File.ReadAllBytes(documento)
        Dim base64 As String = System.Convert.ToBase64String(binarydata, 0, binarydata.Length)
        Dim resultBase As TResultBase(Of DocumentoCreado)

        Dim documentoApi As DocumentoApi = New DocumentoApi() With {
             .Id = CInt(txtCtrIdContrato.Text),
             .Cif = ccdRazonSocial.Codigo,
             .NombreDocumento = nomDocumento,
             .TipoContrato = "",
             .DocumentoBase64 = base64,
             .Usuario = Usuario.Login,
             .Codigo = 0,
             .IsPdf = False,
             .TipoFirma = "",
             .Web = web
        }

        Using documentsWebServiceAjax As New DocumentsWebServiceAjax()
            resultBase = documentsWebServiceAjax.CreateContractDocument(documentoApi)
            If Not resultBase.isSuccess Then
                MostrarMensaje(resultBase.message, TEXTO_ERROR)
            End If
        End Using

        Return resultBase.isSuccess
    End Function

    Private Function GetDetallesContrato(codContrato As Integer) As DetallesContrato
        Return ContratosWebServiceAjax.GetContractDetails(codContrato)
    End Function

    Private Function GetEstadoContrato(estado As String) As String
        If Not IsNothing(estado) Then
            Select Case estado
                Case "H"
                    Return FIRMA_PARCIAL
                Case "P"
                    Return FIRMA_PENDIENTE
                Case "S"
                    Return FIRMA_COMPLETA
                Case "C"
                    Return FIRMA_CANCELADA
                Case "D"
                    Return FIRMA_CADUCADA
            End Select
        End If
        Return ""
    End Function

    Private Sub AsignarMarcadoresSepa(ByRef inf As InfOrdenCargoCuentaFirma, ByVal infBase As InformeBase, ByVal datos As DataRowCollection)
        Dim nomEmpresaPipes As String() = datos(0)("DES_RAZON_SOCIAL").ToString.Trim.ToUpper(CultureInfo.InvariantCulture).Split("|")
        Dim nomEmpresa As String = ""
        If nomEmpresaPipes.Length = 1 Then
            nomEmpresa = nomEmpresaPipes(0)
        ElseIf nomEmpresaPipes.Length = 2 Then
            nomEmpresa = String.Concat(nomEmpresaPipes(1), " ", nomEmpresaPipes(0))
        ElseIf nomEmpresaPipes.Length = 3 Then
            nomEmpresa = String.Concat(nomEmpresaPipes(2), " ", nomEmpresaPipes(0), " ", nomEmpresaPipes(1))
        End If

        Dim sTipoViaSoci As String = ""
        Dim sCalleSoci As String = ""
        Dim sNumeroSoci As String = ""
        Dim sPortalSoci As String = ""
        Dim sEscaleraSoci As String = ""
        Dim sPisoSoci As String = ""
        Dim sPuertaSoci As String = ""
        DomicilioDatos.ObtieneDireccion(datos(0)("DES_DOMICILIO_SOCI").ToString, sTipoViaSoci, sCalleSoci, sNumeroSoci, sPortalSoci, sEscaleraSoci, sPisoSoci, sPuertaSoci)

        inf.ReferenciaDomiciliacion = datos(0)("REF_MANDATO").ToString.Trim
        inf.Objeto = New CuentaCargo(nomEmpresa,
                                     String.Concat(sTipoViaSoci, "/", sCalleSoci, ", ", If(sNumeroSoci <> "", "número " & sNumeroSoci, ""), If(sPortalSoci <> "", " portal " & sPortalSoci, ""), If(sEscaleraSoci <> "", " escalera " & sEscaleraSoci, ""), If(sPisoSoci <> "", " " & sPisoSoci & "º", ""), If(sPuertaSoci <> "", " " & sPuertaSoci, "")),
                                     datos(0)("COD_POSTAL_SOCI").ToString,
                                     datos(0)("DES_POBLACION_SOCI").ToString,
                                     datos(0)("DES_PROVINCIA_SOCI").ToString, TEXTO_ESPANA,
                                     datos(0)("BIC").ToString.Trim,
                                     datos(0)("IBAN").ToString.Trim)

        inf.sIndFirma = infBase.sIndFirma
        inf.NumFirmantes = infBase.NumFirmantes
        inf.NomPersonaFirma = infBase.NomPersonaFirma
        inf.NomPersonaFirma2 = infBase.NomPersonaFirma2
        inf.CodPersonaFirma = infBase.CodPersonaFirma
        inf.CodPersonaFirma2 = infBase.CodPersonaFirma2

        inf.sLocalidad = datos(0)("DES_PROVINCIA_SOCI").ToString
        inf.sFecha = datos(0)("FEC_FIRMA").ToString
    End Sub

    Public Function EsEliminable(nombre As String, usuario As String) As Boolean

        If usuario Is Nothing Then
            Throw New ArgumentNullException(NameOf(usuario))
        End If

        Dim regex As Regex = New Regex(EXPRESION_REGULAR_VERSION_DOCUMENTO)

        If Not regex.IsMatch(nombre) AndAlso Not usuario.Equals("Firma OTP", StringComparison.InvariantCultureIgnoreCase) Then
            Return True
        End If

        Return False
    End Function

    Public Function ValidarActividadesEspecificasSinFirmantes() As Boolean
        Dim estadoContrato As String = ddlCtrEstadoContrato.SelectedValue
        Dim estadoContratoOculto As String = ddlCtrEstadoContratoOculto.SelectedValue
        Dim tipoContrato As String = txtTipoContrato.Text
        Dim fechaLimiteContratoAsociado As New Date(2024, 6, 26, 0, 0, 0, DateTimeKind.Local)
        Dim fechaAltaContrato As Date = Date.ParseExact(hfFecAlta.Value, "dd/MM/yyyy", System.Globalization.DateTimeFormatInfo.InvariantInfo)

        If (estadoContrato = "V" OrElse estadoContrato = "F") AndAlso estadoContratoOculto = "C" AndAlso tipoContrato = ACTIVIDADES_ESPECIFICAS AndAlso GetNumDocumentosArchivados() = 0 AndAlso fechaAltaContrato > fechaLimiteContratoAsociado Then
            MostrarMensaje(TEXTO_OBLIGATORIO_DOCUMENTO, TEXTO_ERROR)
            AddLoadScript("ForzarEstadoEnCurso();")
            AddLoadScript("filtrarEstados();")
            AddLoadScript("EvaluaEstado(true);")
            Return False
        End If

        Return True
    End Function

    Public Function GetNumDocumentosArchivados() As Integer
        Using documentsWebServiceAjax As New DocumentsWebServiceAjax()
            Dim documentos As List(Of DocumentoContrato) = documentsWebServiceAjax.GetContractDocuments(txtCtrIdContrato.Text)

            If documentos IsNot Nothing AndAlso documentos.Count > 0 Then
                Return documentos.Where(Function(x) x.SignType = "").Count
            End If
        End Using

        Return 0
    End Function

    Private Function GetFechaCartasBaja(morosidad As Boolean) As String
        Dim fechaFirma As Date = calCtrFecFirma1.Fecha
        Dim fechaInicioFact As Date = calFecIniFact.Fecha
        Dim fechaCalculo As Date
        Dim fechaHoy As Date = DateTime.Today

        If ContratoDatos.EsContratoMigrado(txtCtrCodContrato.Text, tc) <> 1 Then
            fechaCalculo = New Date(fechaHoy.Year, fechaFirma.Month, fechaFirma.Day, 0, 0, 0, DateTimeKind.Local)
        Else
            fechaCalculo = New Date(fechaHoy.Year, fechaInicioFact.Month, fechaInicioFact.Day, 0, 0, 0, DateTimeKind.Local)
        End If

        If Not morosidad Then
            If fechaCalculo <= fechaHoy Then
                fechaCalculo = fechaCalculo.AddYears(1)
            End If
            fechaCalculo = fechaCalculo.AddDays(-1)
        Else
            If fechaCalculo > fechaHoy Then
                fechaCalculo = fechaCalculo.AddYears(-1)
            End If
        End If

        Return String.Concat(fechaCalculo.Day, " de ", UtilidadesSPA.GetTextoMes(fechaCalculo.Month), " de ", fechaCalculo.Year)
    End Function

    Private Shared Function GetFechaFinAutonomo(fechaFirmaString As String, indRenovable As String) As String
        If indRenovable = "S" Then
            Return "Renovable tácitamente"
        ElseIf indRenovable = "N" AndAlso fechaFirmaString IsNot Nothing Then
            Dim fechaFirma As Date = Convert.ToDateTime(fechaFirmaString, CultureInfo.CurrentCulture)
            fechaFirma = fechaFirma.AddYears(1)
            fechaFirma = fechaFirma.AddDays(-1)
            Return fechaFirma.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture)
        End If
        Return ""
    End Function

    Public Shared Function ConvertirBase64APdf(ByVal base64 As String) As String
        Using arquitecturaWebServiceAjax As New ArquitecturaWebServiceAjax
            Return arquitecturaWebServiceAjax.ConvertDocToPdf(base64)
        End Using
    End Function

    Public Shared Sub CambiarCaracteristicasDocumentoAPdf(ByVal inf As InformeBase, ByVal nomDocumento As String, ByVal codContrato As String, ByRef isPdf As Boolean, ByRef base64 As String)
        isPdf = True
        base64 = ConvertirBase64APdf(base64)
        inf.NomDocumento = nomDocumento
    End Sub

    Public Function PuedeGenerarDocFirmaDirectivo() As Boolean
        If (ddlCtrEstadoContrato.SelectedValue <> "V" OrElse ddlCtrEstadoContratoOculto.SelectedValue <> "V") AndAlso (chkGenerarFirmado.Checked OrElse chkGenerarFirmaOtp.Checked) Then
            If ccdCtrDirectivo1 IsNot Nothing AndAlso ccdCtrDirectivo1.Codigo <> "" AndAlso Not TieneFirmaEscaneada(ccdCtrDirectivo1.InfoExtra("COD_PERSONA")) Then
                MostrarMensaje("El firmante " & Replace(ccdCtrDirectivo1.Descripcion, "|", " ") & " no tiene firma escaneada y no es posible generar documentación firmada.")
                Return False
            End If
            If ccdCtrDirectivo2 IsNot Nothing AndAlso ccdCtrDirectivo2.Codigo <> "" AndAlso Not TieneFirmaEscaneada(ccdCtrDirectivo2.InfoExtra("COD_PERSONA")) Then
                MostrarMensaje("El firmante " & Replace(ccdCtrDirectivo2.Descripcion, "|", " ") & " no tiene firma escaneada y no es posible generar documentación firmada.")
                Return False
            End If
        End If
        Return True
    End Function

    Public Shared Function TieneFirmaEscaneada(ByVal codPersona As Integer) As Boolean
        Dim pathFirma As String = $"{ConfArq.Instance.GetValue("rutaRecursosInformes") }\firmas\1#{codPersona }.gif"
        Return File.Exists(pathFirma)
    End Function

    Public Sub DocumentacionRellenaFirmantesQp(ByRef inf As InformeBase, ByVal tabla As DataTable)
        If inf Is Nothing Then
            Throw New ArgumentNullException(NameOf(inf))
        End If

        If tabla Is Nothing Then
            Throw New ArgumentNullException(NameOf(tabla))
        End If

        If tabla.Rows.Count > 0 AndAlso Not String.IsNullOrEmpty(tabla.Rows(0)("COD_EMPLEADO1").ToString) Then

            Dim nomFirmantePipes As String() = tabla.Rows(0)("NOM_PERSONA1").ToString.Split("|")
            Dim nomNotarioPipes As String() = tabla.Rows(0)("NOM_NOTARIO1").ToString.Split("|")
            Dim nomFirmante As String = ""
            Dim dni As String = tabla.Rows(0)("NUM_DOCUMENTO1").ToString
            Dim textFirmante1 As String = TEXTO_NOTARIO
            Dim nomNotario1 As String = ""

            If nomFirmantePipes.Length = 1 Then
                nomFirmante = nomFirmantePipes(0)
            ElseIf nomFirmantePipes.Length = 2 Then
                nomFirmante = String.Concat(nomFirmantePipes(1), " ", nomFirmantePipes(0))
            ElseIf nomFirmantePipes.Length = 3 Then
                nomFirmante = String.Concat(nomFirmantePipes(2), " ", nomFirmantePipes(0), " ", nomFirmantePipes(1))
            End If

            inf.sFirmanteSPFM = nomFirmante

            If nomNotarioPipes.Length = 1 Then
                nomNotario1 = nomNotarioPipes(0)
            ElseIf nomNotarioPipes.Length = 2 Then
                nomNotario1 = String.Concat(nomNotarioPipes(1), " ", nomNotarioPipes(0))
            ElseIf nomNotarioPipes.Length = 3 Then
                nomNotario1 = String.Concat(nomNotarioPipes(2), " ", nomNotarioPipes(0), " ", nomNotarioPipes(1))
            End If

            textFirmante1 = textFirmante1.Replace("FECHA", tabla.Rows(0)("FEC_PODER1").ToString)
            textFirmante1 = textFirmante1.Replace("PODER", tabla.Rows(0)("NUM_PODER1").ToString)
            textFirmante1 = textFirmante1.Replace("PROVINCIA/POBLACION", "Madrid")
            textFirmante1 = textFirmante1.Replace("NOM_NOTARIO", nomNotario1)
            textFirmante1 = String.Concat(dni, textFirmante1)

            If Not String.IsNullOrEmpty(tabla.Rows(0)("COD_EMPLEADO2").ToString) Then
                Dim textoFirmante2 As String = TEXTO_FIRMANTE2
                Dim textNotario2 As String = TEXTO_NOTARIO
                Dim nomFirmantePipes2 As String() = tabla.Rows(0)("NOM_PERSONA2").ToString.Split("|")
                Dim nomNotarioPipes2 As String() = tabla.Rows(0)("NOM_NOTARIO2").ToString.Split("|")
                Dim nomFirmante2 As String = ""
                Dim nomNotario2 As String = ""

                If nomFirmantePipes2.Length = 1 Then
                    nomFirmante2 = nomFirmantePipes2(0)
                ElseIf nomFirmantePipes2.Length = 2 Then
                    nomFirmante2 = String.Concat(nomFirmantePipes2(1), " ", nomFirmantePipes2(0))
                ElseIf nomFirmantePipes2.Length = 3 Then
                    nomFirmante2 = String.Concat(nomFirmantePipes2(2), " ", nomFirmantePipes2(0), " ", nomFirmantePipes2(1))
                End If

                If nomNotarioPipes2.Length = 1 Then
                    nomNotario2 = nomNotarioPipes2(0)
                ElseIf nomNotarioPipes2.Length = 2 Then
                    nomNotario2 = String.Concat(nomNotarioPipes2(1), " ", nomNotarioPipes2(0))
                ElseIf nomNotarioPipes2.Length = 3 Then
                    nomNotario2 = String.Concat(nomNotarioPipes2(2), " ", nomNotarioPipes2(0), " ", nomNotarioPipes2(1))
                End If

                textoFirmante2 = textoFirmante2.Replace("NOMBRE_FIRMANTE", nomFirmante2)
                textoFirmante2 = textoFirmante2.Replace("IDENTIFICADOR", tabla.Rows(0)("NUM_DOCUMENTO2").ToString)
                textNotario2 = textNotario2.Replace("FECHA", tabla.Rows(0)("FEC_PODER2").ToString)
                textNotario2 = textNotario2.Replace("PODER", tabla.Rows(0)("NUM_PODER2").ToString)
                textNotario2 = textNotario2.Replace("PROVINCIA/POBLACION", "Madrid")
                textNotario2 = textNotario2.Replace("NOM_NOTARIO", nomNotario2)

                inf.sDNIFirmanteSPFM = String.Concat(textFirmante1, textoFirmante2, textNotario2)
            Else
                inf.sDNIFirmanteSPFM = textFirmante1
            End If

        End If
    End Sub

End Class