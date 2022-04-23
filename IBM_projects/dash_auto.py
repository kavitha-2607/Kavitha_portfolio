import pandas as pd
import dash
from dash import Dash, html, dcc, dash_table
from dash.dependencies import Input, Output, State
import plotly.graph_objects as go
import plotly.express as px
from dash import no_update

app = dash.Dash(__name__)

# REVIEW1: Clear the layout and do not display exception till callback gets executed
app.config.suppress_callback_exceptions = True

# Read the automobiles data into pandas dataframe
auto_data =  pd.read_csv('automobileEDA.csv',
                            encoding = "ISO-8859-1",
                            )
def compute_info(auto_data, entered_dw):
    # Select data
    df =  auto_data[auto_data['drive-wheels']==str(entered_dw)]
    filtered_df = df.groupby(['drive-wheels','body-style'])['price'].mean().reset_index()
    return filtered_df

#Layout Section of Dash

app.layout = html.Div(children=[#TASK 3A
html.H1('Car Automobile Components', style = {'textAlign': 'center'}),
     #outer division starts
     html.Div([
                   # First inner divsion for  adding dropdown helper text for Selected Drive wheels
                    html.Div(["Drive Wheels Type:", dcc.Dropdown( id= 'dropdown', options = [
                    {'label': '4 wheel Drive(4wd)', 'value': '4wd'},
                    {'label': 'Front Wheel Drive (fwd)', 'value':'fwd'},
                    {'label': 'Rear wheel Drive(rwd)', 'value':'rwd'}
                    ],
                    value = '4wd'
                        #TASK 3B
                     ),
                    ]),


                    #TASK 3C

                    #Second Inner division for adding 2 inner divisions for 2 output graphs
                    html.Div([
                    html.Div(dcc.Graph(id = 'pie-plot')),
                    html.Div(dcc.Graph(id = 'bar-plot'))
                        #TASK 3D
                    ], style={'display': 'flex'}),


    ])
    #outer division ends
])
#layout ends

#Place to add @app.callback Decorator
#TASK 3E
@app.callback( [
               Output(component_id='pie-plot', component_property='figure'),
               Output(component_id='bar-plot',component_property='figure')
               ],
               Input(component_id = 'dropdown', component_property = 'value'))
# Computation to callback function and return graph

def get_graph(entered_dw):

    # Compute required information for creating graph from the data
    df = compute_info(auto_data, entered_dw)

     # Line plot for carrier delay
    pie_fig = px.pie(df, values = 'price', names = 'body-style', title = 'Body-style by price')
    bar_fig = px.bar(df, x = 'body-style', y = 'price', barmode = 'group')

    return[pie_fig, bar_fig]

# Run the app
if __name__ == '__main__':
    app.run_server()
