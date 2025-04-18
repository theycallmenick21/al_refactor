file_path = 'C:/Users/niban/Documents/ALEVERI/al_refactor/en-data.txt'

with open(file_path, 'r', encoding='utf-8') as file:
    content = file.read()

translations_all_3 = {
    "Población": "Population",
    "Provincia": "Province",
    "Calle": "Street",
    "Escalera": "Staircase",
    "Número": "Number",
    "Fax": "Fax",
    "Teléfono": "Phone",
    "Piso": "Floor",
    "Portal": "Portal",
    "Tipo de vía": "Type of road",
    "C.P.": "Postal Code",
    "A la atención de": "Attention to",
    "Email": "Email",
    "Dirección Email": "Email Address",
    "Oficina Contable": "Accounting Office",
    "Órgano Gestor": "Managing Body",
    "Órgano Competente": "Competent Body",
    "Referencia": "Reference",
    "Nuevo Anexo": "New Annex",
    "Primer Apellido": "First Surname",
    "Segundo Apellido": "Second Surname",
    "Cargo": "Position",
    "Causa de baja": "Reason for dismissal",
    "Contrato Antiguo": "Old Contract",
    "Contrato Nuevo": "New Contract",
    "Directivo": "Executive",
    "Email del cliente": "Client's Email",
    "Fecha de Baja": "Dismissal Date",
    "Firma Cliente": "Client's Signature",
    "Firma de Quirón Prevención": "Quirón Prevention's Signature",
    "Protocolo": "Protocol",
    "Motivo de Descuento": "Reason for Discount",
    "Plazo de Pago": "Payment Term",
    "Precio": "Price",
    "Alto Riesgo": "High Risk",
    "Bajo Riesgo": "Low Risk",
    "Tarifa": "Rate",
    "Datos Centro de Trabajo": "Work Center Data",
    "Datos de Contacto asociados a filial": "Contact Data associated with branch",
    "Fecha de última Renovación": "Last Renewal Date",
    "Facturación de Reconocimientos": "Billing of Recognitions",
    "Filtros de búsqueda": "Search Filters",
    "Buscar": "Search",
    "Grabar": "Save",
    "Importe Hospital Digital": "Digital Hospital Amount",
    "Histórico de Colaboradores": "Collaborator History",
    "Histórico de Tarifas": "Tariff History",
    "Modalidades antes de Bayes": "Modalities before Bayes",
    "Modalidades contrato": "Contract Modalities",
    "Autónomos": "Self-employed",
    "Bolsa de Horas": "Hours Pool",
    "Datos de los Colaboradores": "Collaborator Data",
    "Anexo Renovación": "Renewal Annex",
    "Facturación": "Billing",
    "Renovación de Precios de Concierto": "Price Renewal of Agreement",
    "Motivo de Descuento": "Discount Reason",
    "Periodo de Facturación": "Billing Period",
    "Importe según Tarifa": "Amount according to Rate",
    "Incluye": "Includes",
    "Total": "Total",
    "Observaciones de baja": "Dismissal Observations",
    "Contactos del Cliente": "Client Contacts",
    "Domiciliación Bancaria": "Banking domiciliation",
    "Datos Organismos Públicos": "Public Agency Data",
    "Datos Contrato": "Contract Data",
    "Número total de Pruebas VSI en el contrato": "Total number of VSI tests in the contract",
    "Descargar Centros de Trabajo": "Download Work Centers",
    "Firma": "Signature",
    "Razón Social": "Social Name",
    "Número de Centros": "Number of Centers",
    "Razon Social": "Social Reason",
    "CNAE": "CNAE",
    "Dar de baja contratos AAEE": "Terminate AAEE contracts",
    "Búsqueda": "Search",
    "Observaciones del contrato": "Contract observations",
    "Prueba": "Test",
    "Otro Pagador": "Other Payer",
    "Nuevo Anexo": "New Annex",
    "Nuevo Anexo AAEE": "New Annex AAEE",
    "Nuevo Anexo Analiticas": "New Annex Analytics",
    "Nuevo Anexo Renovacion": "New Annex Renewal",
    "Primer Apellido": "First Surname",
    "Segundo Apellido": "Second Surname",
    "Observaciones de baja": "Dismissal Observations",
    "Cargo": "Position",
    "Causa de baja": "Reason for dismissal",
    "Contrato Antiguo": "Old Contract",
    "Contrato Nuevo": "New Contract",
    "Directivo": "Executive",
    "Email": "Email",
    "Fecha de Baja": "Dismissal Date",
    "Por parte del Cliente": "By Client",
    "Notario": "Notary",
    "Primer Representante": "First Representative",
    "Segundo Representante": "Second Representative",
    "Por parte de Quirón Prevención": "By Quirón Prevention",
    "DNI/CIF": "DNI/CIF",
    "Nombre": "Name",
    "Razón Social": "Social Name",
    "Observaciones de baja": "Dismissal Observations",
    "Población": "Population",
    "Poder": "Power",
    "%": "Percentage",
    "Protocolo": "Protocol",
    "Desde Trimestre": "From Quarter",
    "%Desc. Méd.": "Medical Discount %",
    "%Desc.Reco.Alto Riesgo": "High Risk Recognition Discount %",
    "%Desc.Reco.Bajo Riesgo": "Low Risk Recognition Discount %",
    "%Desc. Téc.": "Technical Discount %",
    "%Desc. Téc. Horas": "Technical Discount Hours %",
    "Día de Pago": "Payment Day",
    "Eliminar IPC": "Delete IPC",
    "Eliminar IPC Fija": "Delete Fixed IPC",
    "Según los permisos que usted tiene no puede introducir la cuenta bancaria del contrato.": "According to your permissions, you cannot enter the bank account of the contract.",
    "Fecha Finalización": "End Date",
    "Fecha de última Renovación": "Last Renewal Date",
    "Facturación de Reconocimientos": "Billing of Recognitions",
    "Filtros de búsqueda": "Search Filters",
    "Buscar": "Search",
    "Forma de Pago": "Payment Method",
    "Analíticas Compuestas": "Composite Analytics",
    "Perfiles": "Profiles",
    "Analíticas Simples": "Simple Analytics",
    "Doc. cargo en cuenta": "Account charge document",
    "Generar Documentación": "Generate Documentation",
    "Grabar": "Save",
    "Importe Hospital Digital": "Digital Hospital Amount",
    "Importe Hospital Digital": "Digital Hospital Amount",
    "Histórico de Colaboradores": "Collaborator History",
    "Histórico de Tarifas": "Tariff History",
    "Horas": "Hours",
    "Modalidades antes de Bayes": "Modalities before Bayes",
    "Modalidades contrato": "Contract Modalities",
    "Alto Riesgo:": "High Risk:",
    "Bajo Riesgo:": "Low Risk:",
    "Importe Hospital Digital:": "Digital Hospital Amount:",
    "Importe según Tarifa:": "Amount according to Rate:",
    "Importe aplicado:": "Amount applied:",
    "IMPORTE TOTAL VSI PREFACTURADA": "TOTAL VSI PRE-INVOICED AMOUNT",
    "Incluye": "Includes",
    "Anexos": "Annexes",
    "Número de centros": "Number of centers",
    "Centros de Trabajo": "Work Centers",
    "Baja del Contrato": "Contract Termination",
    "Colaborador": "Collaborator",
    "Contactos del Cliente": "Client Contacts",
    "Dirección de envío de facturas": "Invoice Shipping Address",
    "Domiciliación Bancaria": "Banking domiciliation",
    "Firmantes": "Signatories",
    "Indicadores": "Indicators",
    "Renovación de Precios de Concierto": "Renewal of Agreement Prices",
    "Captación/Renovación del Contrato": "Contract Acquisition/Renewal",
    "Facturación": "Billing",
    "Actividades de formación": "Training activities",
    "Datos de los Colaboradores": "Collaborator Data",
    "Anexo Renovación": "Renewal Annex",
    "Datos": "Data",
    "Autónomos": "Self-employed",
    "Bolsa de Horas": "Hours Pool",
    "Modalidades": "Modalities",
    "Productos": "Products",
    "Trabajadores Totales": "Total Workers",
    "Limpiar campos": "Clear fields",
    "Precios/Horas": "Prices/Hours",
    "EP": "EP",
    "HI": "HI",
    "Horas Méd": "Medical Hours",
    "Horas Téc": "Technical Hours",
    "MT": "MT",
    "Importe RPF": "RPF Amount",
    "SHE": "SHE",
    "ST": "ST",
    "TOTAL": "TOTAL",
    "Total": "Total",
    "Motivo de Descuento": "Discount Reason",
    "Nº Pedido Fijo": "Fixed Order No.",
    "Nº Pedido Variable": "Variable Order No.",
    "Resto de pruebas VSI": "Rest of VSI tests",
    "Periodo de Facturación": "Billing Period",
    "Plazo de Pago": "Payment Term",
    "Precio": "Price",
    "Médico": "Medical",
    "Técnico": "Technical",
    "Teléfono del cliente": "Client's Phone",
    "Tipo": "Type",
    "Analitica": "Analytical",
    "Perfil": "Profile",
    "Analitica": "Analytical"
}

for original, translated in translations_all_3.items():
    content = content.replace(f"<value>{original}</value>", f"<value>{translated}</value>")

modified_file_path_all_3 = 'C:/Users/niban/Documents/ALEVERI/al_refactor/data/en-data-translated.txt'
with open(modified_file_path_all_3, 'w', encoding='utf-8') as file:
    file.write(content)

modified_file_path_all_3
