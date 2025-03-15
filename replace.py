import re
import datetime

def modificar_ascx(archivo_entrada, archivo_salida):
    try:
        with open(archivo_entrada, 'r', encoding='utf-8') as archivo:
            lineas = archivo.readlines()

        lineas_modificadas = []

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

        i = 0
        while i < len(lineas):
            linea = lineas[i]

            if re.search(r'<rfn:RFNLabel', linea):
                bloque = linea
                i += 1
                while i < len(lineas) and not re.search(r'</rfn:RFNLabel>', lineas[i]):
                    bloque += lineas[i]
                    i += 1
                bloque += lineas[i]  
                
                nueva_linea = re.sub(pattern, transform_label, bloque)
                lineas_modificadas.append(nueva_linea)
            else:
                lineas_modificadas.append(linea)
            i += 1

        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        archivo_salida_con_timestamp = f'{archivo_salida.replace(".ascx", "")}_{timestamp}.ascx'

        with open(archivo_salida_con_timestamp, 'w', encoding='utf-8') as archivo:
            archivo.writelines(lineas_modificadas)

        print(f"Archivo modificado guardado como {archivo_salida_con_timestamp}")

    except Exception as e:
        print(f"Ocurrió un error: {e}")

archivo_entrada = 'C:/Users/niban/Documents/ALEVERI/al_refactor/VSPA01003.ascx'
archivo_salida = 'C:/Users/niban/Documents/ALEVERI/al_refactor/VSPA01003_resultados.ascx'

modificar_ascx(archivo_entrada, archivo_salida)