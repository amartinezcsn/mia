
# Guía rápida – Dashboard Power BI `AdventureWorks Sales`

1. **Conexión a SQL Server**
   - Servidor: *su_servidor_sql*
   - Base de datos: `AdventureWorks2022`
   - Consulta de origen: `SELECT * FROM Sales.vSales`

2. **Modelo**
   - Importar tabla `Sales.vSales`.
   - Crear tabla *Calendar*:
     ```DAX
     Calendar = CALENDAR ( DATE ( 2019, 1, 1 ), DATE ( 2025, 12, 31 ) )
     ```
   - Relación `Calendar[Date]` ↔ `vSales[Date]`.
   - Añadir `Sales.SalesTerritory` y relacionar `SalesTerritoryID`.

3. **Medidas DAX**
   ```DAX
   VTT = SUM ( vSales[TotalSales] )

   VPR = CALCULATE ( [VTT], ALLEXCEPT ( vSales, vSales.TerritoryID ) )

   VPC = CALCULATE ( [VTT], ALLEXCEPT ( vSales, vSales.Category ) )

   MoM VPR % = 
   VAR CurrentMonth = [VPR]
   VAR PrevMonth =
       CALCULATE ( [VPR], DATEADD ( Calendar[Date], -1, MONTH ) )
   RETURN
       DIVIDE ( CurrentMonth - PrevMonth, PrevMonth )
   ```

4. **Visualizaciones**
   - Tarjeta KPI para **VTT**.
   - Gráfico de barras apiladas para **VPR**.
   - Gráfico de columnas para **VPC**.
   - Gráfico de líneas para **%MoM VPR**.
   - Segmentadores: *Región*, *Año*, *Mes*.

5. **Tema**
   - Aplicar paleta azul‑gris corporativa (`#003f5c`, `#2f4b7c`, `#665191`, `#a05195`, `#d45087`).

6. **Interacción**
   - Habilitar *Cross‑filter* entre los visuales.
   - Agregar botón *Reset filters*.

> Guarde el archivo como `AdventureWorks_Sales.pbix`.

Tiempo estimado: 40 min.
