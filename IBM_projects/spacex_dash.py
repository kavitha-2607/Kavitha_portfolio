# Import required libraries
import pandas as pd
import dash
from dash import Dash, html, dcc, dash_table
from dash.dependencies import Input, Output, State
import plotly.graph_objects as go
import plotly.express as px
from dash import no_update

# Read the airline data into pandas dataframe
spacex_df = pd.read_csv("spacex_launch_dash.csv")
max_payload = spacex_df['Payload Mass (kg)'].max()
min_payload = spacex_df['Payload Mass (kg)'].min()
# Create a dash application
app = dash.Dash(__name__)

# Create an app layout
app.layout = html.Div(children=[html.H1('SpaceX Launch Records Dashboard',
                                        style={'textAlign': 'center', 'color': '#503D36',
                                               'font-size': 40}),
                                # TASK 1: Add a dropdown list to enable Launch Site selection
                                dcc.Dropdown(id='site-dropdown',
           options=[
                   {'label': 'All Sites' , 'value': 'ALL' },
                   {'label': 'CCAFS LC-40', 'value': 'CCAFS LC-40'},
                   {'label': 'VAFB SLC-4E', 'value': 'VAFB SLC-4E'},
                   {'label': 'KSC LC-39A', 'value': 'KSC LC-39A'},
                   {'label': 'CCAFS SLC-40', 'value': 'CCAFS SLC-40'}
                   ],
                   value = 'ALL',
                   searchable = True,
                   placeholder='Select a Launch Site',
          style={'width': '80%', 'padding': '3px', 'font-size': '20px', 'textAlign': 'center'}),

                            # Place them next to each other using the division style
                                # The default select value is for ALL sites
                                # dcc.Dropdown(id='site-dropdown',...)
                                html.Br(),

                                # TASK 2: Add a pie chart to show the total successful launches count for all sites
                                # If a specific launch site was selected, show the Success vs. Failed counts for the site
                                html.Div(dcc.Graph(id='success-pie-chart')),
                                html.Br(),
                                html.Br(),
                                html.P("Payload range (Kg):"),
                                # TASK 3: Add a slider to select payload range
                                #dcc.RangeSlider(id='payload-slider',...)
                                dcc.RangeSlider(id='payload-slider',
                                                min=0, max=10000, step=1000,
                                                marks={0: '0', 9600: '9600'},
                                                value=[min_payload, max_payload]),
                                html.Div(dcc.Graph(id='success-payload-scatter-chart'))


                                # TASK 4: Add a scatter chart to show the correlation between payload and launch success

                                ])

# TASK 2:
# Add a callback function for `site-dropdown` as input, `success-pie-chart` as output
@app.callback( Output(component_id='success-pie-chart', component_property='figure'),
               Input(component_id='site-dropdown', component_property='value'))
# TASK 4:
# Add a callback function for `site-dropdown` and `payload-slider` as inputs, `success-payload-scatter-chart` as output

def get_graph_1(launch_site):
    if launch_site == 'ALL':
        df = spacex_df[['Launch Site', 'class']]
        df = pd.DataFrame(df.groupby('Launch Site')['class'].value_counts().reset_index(name = 'counts'))
        df['outcome'] = df['class'].map({0 : 'Failure', 1 : 'Success'})
        fig = px.pie(df, values = 'counts', names = 'outcome', title = 'Success vs. Failure for ALL Launch Sites')
    else:
        df = spacex_df[spacex_df['Launch Site'] == launch_site]
        df = spacex_df[['Launch Site', 'class']]
        df = df[df['Launch Site'] == launch_site]
        df = df.groupby('class').count().reset_index()
        df.rename(columns = {'Launch Site': 'counts'}, inplace = True)
        df['class'] = df['class'].replace({0: 'Failure', 1: 'Success'})
        fig = px.pie(df, values = 'counts', names = 'class', title = 'Success vs. Failure for %s Launch Site' %launch_site)
    return fig

@app.callback( Output(component_id='success-payload-scatter-chart', component_property='figure'),
               Input(component_id='site-dropdown', component_property='value'),
               Input(component_id="payload-slider", component_property="value"))

def get_graph_2(launch_site, payload_range):
    print('Params: {} {}'.format(launch_site, payload_range))
    if launch_site == 'ALL':
        corr_df = spacex_df[(spacex_df['Payload Mass (kg)']>= int(payload_range[0])) & (spacex_df['Payload Mass (kg)']<= int(payload_range[1]))]
        fig_sc = px.scatter(corr_df, x = 'Payload Mass (kg)', y = 'class', color = 'Booster Version Category', title = 'All sites - payload mass between {:8,d}kg and {:8,d}kg'.format(int(payload_range[0]),int(payload_range[1])))
    else:
        corr_df = spacex_df[spacex_df['Launch Site'] == launch_site ]
        corr_df = corr_df[(corr_df['Payload Mass (kg)']>= int(payload_range[0])) & (corr_df['Payload Mass (kg)']<= int(payload_range[1]))]
        fig_sc = px.scatter(corr_df, x = 'Payload Mass (kg)', y = 'class', color = 'Booster Version Category',  title = 'All sites - payload mass between {:8,d}kg and {:8,d}kg'.format(int(payload_range[0]),int(payload_range[1])))

    return fig_sc

# Run the app
if __name__ == '__main__':
    app.run_server()
