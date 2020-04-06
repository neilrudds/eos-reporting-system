<%@ Page Title="Add Unit" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="AddUnit.aspx.cs" Inherits="ReportingSystemV2.CPanel.AddUnit" EnableEventValidation="false" %>
<asp:Content ID="AddUnitContent" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <div class="row acc-wizard">
      <div class="col-md-3" style="padding-left: 2em;">
        <p style="margin-bottom: 2em;">
          Follow the steps below to add a new datalogger to the reporting system.
        </p>
        <ol class="acc-wizard-sidebar">
          <li class="acc-wizard-todo"><a href="#Unit">Create a Site</a></li>
          <li class="acc-wizard-todo"><a href="#Comms">Communications</a></li>
          <li class="acc-wizard-todo acc-wizard-active"><a href="#History">History</a></li>
          <li class="acc-wizard-todo"><a href="#Summary">Review & Save</a></li>
        </ol>
      </div>
      <div class="col-md-9" style="padding-right: 2em;">
        <div id="accordion-demo" class="panel-group">
          
          <%--Step 1--%>
          <div class="panel panel-default">
            <div class="panel-heading">
              <h4 class="panel-title">
                <%--<a href="#Unit" data-parent="#accordion-demo" data-toggle="collapse">--%>
                  Add a Datalogger and assign to a Site
                <%--</a>--%>
              </h4>
            </div>
            <div id="Unit" class="panel-collapse collapse" style="height: 36.4000015258789px;">
              <div class="panel-body">
                <div id="form-Unit">

                    <p>
                        To add a new unit you must first complete the steps in this wizard:
                    </p>
                    <ul>
                        <li>Identify the datalogger unit connected to the site by inserting the 9 digit serial number.
                        </li>
                        <li>Give details about the site, such as: The overall site name, number of connected engines, first engine address and the comap serial numbers.
                        </li>
                    </ul>
                    Note that you cannot connect a new site without first completing this wizard, once the wizard has been completed the datalogger will be able to 
                    aquire its settings upon its first mobile network connection.
                  <p></p>

                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-md-4 control-label">Unit Serial No.</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbUnitSerial" runat="server" CssClass="form-control input-md" placeholder="Datalogger Serial" TabIndex="1"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvUnitSerial" runat="server" 
                                    ControlToValidate="tbUnitSerial"
                                    ForeColor="Red"
                                    ClientValidationFunction="isUnitSerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">Datalogger Model</label>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlUnitModel" CssClass="form-control select fa-caret-down" runat="server" TabIndex="2"
                                     OnSelectedIndexChanged="ddlUnitModel_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem>Mx2i Pro (Silver)</asp:ListItem>
                                    <asp:ListItem>Mx2i Turbo (Gold)</asp:ListItem>
                                    <asp:ListItem>AX9 Turbo</asp:ListItem>
                                    <asp:ListItem>NX-900</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">Email Alert's</label>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlPrimaryEmailAddr" CssClass="form-control select fa-caret-down" runat="server" TabIndex="3"
                                     OnSelectedIndexChanged="ddlPrimaryEmailAddr_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <asp:RequiredFieldValidator ID="rfvPrimaryEmail" runat="server" ControlToValidate="ddlPrimaryEmailAddr"
                                    ErrorMessage="Please select an email address" InitialValue="-1" Display="Dynamic" ForeColor="Red" ValidationGroup="vgStep1"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Select Site</label>
                                    <div class="col-md-4">
                                        <asp:DropDownList ID="ddlExistingSites" CssClass="form-control select fa-caret-down" runat="server" TabIndex="4"
                                            OnSelectedIndexChanged="ddlExistingSites_SelectedIndexChanged" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Or Add New</label>
                                    <div class="col-md-4">
                                        <asp:TextBox ID="tbNewSiteName" runat="server" CssClass="form-control input-md" placeholder="Site Name" TabIndex="5"></asp:TextBox>
                                    </div>
                                    <div class="col-md-4">
                                        <asp:CustomValidator ID="cvSiteName" runat="server"
                                            ControlToValidate="tbNewSiteName"
                                            ForeColor="Red"
                                            ClientValidationFunction="isSiteNameValid"
                                            Display="Dynamic"
                                            Enabled="true"
                                            ValidateEmptyText="true" ValidationGroup="vgStep1">
                                        </asp:CustomValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                            <label class="col-md-4 control-label">No. of Engines</label>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlComapCount" CssClass="form-control select fa-caret-down" runat="server" TabIndex="6">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 1#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial1" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="7"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial1" runat="server" 
                                    ControlToValidate="tbComapSerial1"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap1SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 2#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial2" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="8"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial2" runat="server" 
                                    ControlToValidate="tbComapSerial2"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap2SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 3#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial3" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="9"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial3" runat="server" 
                                    ControlToValidate="tbComapSerial3"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap3SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 4#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial4" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="10"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial4" runat="server" 
                                    ControlToValidate="tbComapSerial4"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap4SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 5#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial5" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="11"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial5" runat="server" 
                                    ControlToValidate="tbComapSerial5"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap5SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 6#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial6" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="12"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial6" runat="server" 
                                    ControlToValidate="tbComapSerial6"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap6SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 7#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial7" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="13"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial7" runat="server" 
                                    ControlToValidate="tbComapSerial7"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap7SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">ComAp 8#</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbComapSerial8" runat="server" CssClass="form-control input-md" placeholder="Serial No." TabIndex="14"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:CustomValidator ID="cvComapSerial8" runat="server" 
                                    ControlToValidate="tbComapSerial8"
                                    ForeColor="Red"
                                    ClientValidationFunction="isComap8SerialValid"
                                    Display="Dynamic"
                                    Enabled="true"
                                    ValidateEmptyText="true" ValidationGroup="vgStep1">
                                </asp:CustomValidator>
                            </div>
                        </div>

                    </div>

                <div class="acc-wizard-step"><%--<button id="btnUnitNext" runat="server" class="btn btn-primary" type="submit" validationgroup="vg1" causesvalidation="true">Next Step </button>--%>
                    <asp:Button ID="unitNext" runat="server" Text="Next Step " OnClientClick="openWiz('#Comms'); return false;" ValidationGroup="vgStep1" CausesValidation="true"  CssClass="btn btn-primary"/>
                </div>
                </div>
              </div> <!--/.panel-body -->
            </div> <!-- /#Site -->
          </div> <!-- /.panel.panel-default -->

          <%--Step 2--%>
          <div class="panel panel-default">
            <div class="panel-heading">
              <h4 class="panel-title">
                <%--<a href="#Comms" data-parent="#accordion-demo" data-toggle="collapse">--%>
                  Configure communications settings
                <%--</a>--%>
              </h4>
            </div>
            <div id="Comms" class="panel-collapse collapse" style="height: 36.4000015258789px;">
              <div class="panel-body">
                  <div id="form-Comms">
                      <p>
                          Next, you must configure the communications settings.
                      </p>
                      This will include:
                      <ul>
                          <li>Selecting the desired port for connection to the controller, RS232-Front or RS485-Rear.</li>
                          <li>Selecting the desired baud rate (57600bps recomended).</li>
                          <li>Selecting the address of the first controller, all additional controllers must be in sequence i.e. 2,3,4</li>
                          <li>Defining the Endress & Hauser heat meter addresses (8 max).</li>
                      </ul>

                      <asp:UpdatePanel ID="UpdPnlCommunications" runat="server" UpdateMode="Conditional">
                          <ContentTemplate>
                              <div class="form-horizontal">
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">Port</label>
                                      <div class="col-md-4">
                                          <div class="span6 radio">
                                              <asp:RadioButtonList ID="rblPort" runat="server" OnSelectedIndexChanged="rblPort_SelectedIndexChanged" AutoPostBack="true">
                                                  <asp:ListItem Text="RS232 (Front)" Value="rs232"></asp:ListItem>
                                                  <asp:ListItem Text="RS485 (Rear)" Value="rs485" Selected="True"></asp:ListItem>
                                              </asp:RadioButtonList>
                                          </div>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">Baud Rate</label>
                                      <div class="col-md-4">
                                          <asp:DropDownList ID="ddlBaud" CssClass="form-control select fa-caret-down" runat="server">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">Ethernet Module</label>
                                      <div class="col-md-4">
                                          <asp:DropDownList ID="ddlEthernetEnabled" CssClass="form-control select fa-caret-down" runat="server" TabIndex="2">
                                              <asp:ListItem>Disabled</asp:ListItem>
                                              <asp:ListItem>Enabled</asp:ListItem>
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">First ComAp MB ID</label>
                                      <div class="col-md-4">
                                          <asp:DropDownList ID="ddlSlaveAddr" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlSlaveAddr_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">Heat Meter MB ID's</label>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_01" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_01_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_02" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_02_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <div class="col-md-4"></div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_03" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_03_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_04" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_04_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <div class="col-md-4"></div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_05" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_05_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_06" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_06_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <div class="col-md-4"></div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_07" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_07_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlHM_08" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlHM_08_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">Steam Meter MB ID's</label>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlSM_01" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlSM_01_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlSM_02" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlSM_02_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <div class ="col-md-4"></div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlSM_03" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlSM_03_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlSM_04" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlSM_04_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-md-4 control-label">Gas Meter MB ID's</label>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlGM_01" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlGM_01_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                      <div class="col-md-2">
                                          <asp:DropDownList ID="ddlGM_02" Enabled="false" CssClass="form-control select fa-caret-down" runat="server" OnSelectedIndexChanged="ddlGM_02_SelectedIndexChanged" AutoPostBack="true">
                                          </asp:DropDownList>
                                      </div>
                                  </div>
                              </div>
                          </ContentTemplate>
                      </asp:UpdatePanel>

                      <div class="acc-wizard-step">
                          <button class="btn" type="reset">Go Back</button>
                          <button class="btn btn-primary" type="submit">Next Step</button>
                      </div>
                  </div>
              </div> <!--/.panel-body -->
            </div> <!-- /#Comms -->
          </div> <!-- /.panel.panel-default -->

          <%--Step 3--%>
          <div class="panel panel-default">
            <div class="panel-heading">
              <h4 class="panel-title">
                <%--<a href="#History" data-parent="#accordion-demo" data-toggle="collapse">--%>
                  Process the ComAp history columns
                <%--</a>--%>
              </h4>
            </div>
            <div id="History" class="panel-collapse collapse in">
              <div class="panel-body">
                  <div id="form-History">
                      <p>
                          This section will allow you to configure the mapping of the ComAps history columns.
                    You must first upload the comms object file that is found in GenConfig while connected to the desired site.
                    This file will then be validated against the current columns in the Reporting System to ensure that the match all other sites.
                    Any columns that cannot be automatically paired with a relevant column must be updated by select its name from the drop down list. Each column can only be used once
                    and any new columns must be approved by a systems administrator.
                      </p>
                      <div class="form-horizontal">
                          <div class="form-group">
                              <label class="col-md-4 control-label">Upload</label>
                              <div class="col-md-4">
                                  <asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="true" />
                                  <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="UploadMultipleFiles" accept="text/plain" />
                                  <asp:Label ID="lblSuccess" runat="server" ForeColor="Green" />
                                  <hr />
                              </div>
                              <div class="col-md-12">
                                  <asp:UpdatePanel ID="UpdatePanelUpload" runat="server" UpdateMode="Conditional">
                                      <ContentTemplate>
                                          <asp:GridView ID="historyResult" runat="server" AutoGenerateColumns="False" OnRowDataBound="gridHistoryResult_RowDataBound" CssClass="table table-striped table-condensed">
                                              <Columns>
                                                  <asp:BoundField DataField="Name" HeaderText="Column Name" />
                                                  <asp:BoundField DataField="Type" HeaderText="Column Type" />
                                                  <asp:BoundField DataField="Len" HeaderText="Length (Bytes)" />
                                                  <asp:BoundField DataField="Dec" HeaderText="Decimals" />
                                                  <asp:TemplateField HeaderText="Header Name">
                                                      <ItemTemplate>
                                                          <asp:DropDownList ID="ddlHeaderName" 
                                                              DataTextField="History_Header" DataValueField="id" DataSourceID="HeadersDataSource"
                                                              OnSelectedIndexChanged="ddlHeaderName_SelectedIndexChanged"
                                                              AppendDataBoundItems="True"
                                                              AutoPostBack="true" runat="server"
                                                              style="width: 100%">
                                                               <asp:ListItem Value="-1">
                                                                   -- Select --
                                                                </asp:ListItem>
                                                              <asp:ListItem Value="-2">
                                                                   **Unknown**
                                                                </asp:ListItem>    
                                                          </asp:DropDownList>
                                                      </ItemTemplate>
                                                  </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Description">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lblDescription" runat="server"></asp:Label>
                                                      </ItemTemplate>
                                                  </asp:TemplateField>
                                              </Columns>
                                          </asp:GridView>
                                      </ContentTemplate>
                                  </asp:UpdatePanel>
                                  <asp:LinqDataSource ID="HeadersDataSource" runat="server" ContextTypeName="ReportingSystemV2.ReportingSystemDataContext" TableName="ComAp_Headers" OrderBy="History_Header" />
                              </div>
                          </div>

                      </div>
                      <div class="acc-wizard-step"><button class="btn" type="reset">Go Back</button> <asp:button ID="ReviewBtn" runat="server" class="btn btn-primary"
                           type="submit" Text="Next Step" OnClick="ReviewBtn_Click" ValidationGroup="vg2"></asp:button></div>
                  </div>
              </div> <!--/.panel-body -->
            </div> <!-- /#History -->
          </div> <!-- /.panel.panel-default -->

          <%--Step 4--%>
          <div class="panel panel-default">
            <div class="panel-heading">
              <h4 class="panel-title">
                <%--<a href="#Summary" data-parent="#accordion-demo" data-toggle="collapse">--%>
                  Review and Save
                <%--</a>--%>
              </h4>
            </div>
            <div id="Summary" class="panel-collapse collapse" style="height: 36.4000015258789px;">
                <div class="panel-body">
                    <div id="form-Summary">
                        <p>
                            Naturally, the last thing you'll want to do is test your
                    page with the accordion wizard. Once you've confirmed that
                    it's working as expected, release it on the world. Your
                    users will definitely appreciate the feedback and guidance
                    it gives to multi-step and complex tasks on your web site.
                        </p>

                        <div class="row">
                            <div class="col-md-4">
                            <table class="table table-condensed">
                              <thead>
                                <tr>
                                  <th colspan="2"><h3>Site.</h3></th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <th scope="row"><strong>Unit Serial</strong></th>
                                  <td><asp:Label ID="lblUnitSerial" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                  <th scope="row"><strong>Site Name</strong></th>
                                  <td><asp:Label ID="lblSiteName" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                  <th scope="row"><strong>CHP 01</strong></th>
                                  <td><asp:Label ID="lblGensetName01" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                  <th scope="row"><strong>CHP 02</strong></th>
                                  <td><asp:Label ID="lblGensetName02" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                  <th scope="row"><strong>CHP 03</strong></th>
                                  <td><asp:Label ID="lblGensetName03" runat="server" Text=""></asp:Label></td>
                                </tr>
                                  <tr>
                                  <th scope="row"><strong>CHP 04</strong></th>
                                  <td><asp:Label ID="lblGensetName04" runat="server" Text=""></asp:Label></td>
                                </tr>
                                  <tr>
                                  <th scope="row"><strong>CHP 05</strong></th>
                                  <td><asp:Label ID="lblGensetName05" runat="server" Text=""></asp:Label></td>
                                </tr>
                                  <tr>
                                  <th scope="row"><strong>CHP 06</strong></th>
                                  <td><asp:Label ID="lblGensetName06" runat="server" Text=""></asp:Label></td>
                                </tr>
                                  <tr>
                                  <th scope="row"><strong>CHP 07</strong></th>
                                  <td><asp:Label ID="lblGensetName07" runat="server" Text=""></asp:Label></td>
                                </tr>
                                  <tr>
                                  <th scope="row"><strong>CHP 08</strong></th>
                                  <td><asp:Label ID="lblGensetName08" runat="server" Text=""></asp:Label></td>
                                </tr>
                              </tbody>
                            </table>
                          </div>

                            <div class="col-md-4">
                                <table class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th colspan="2">
                                                <h3>Communications.</h3>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th scope="row"><strong>Port</strong></th>
                                            <td><asp:Label ID="lblCommPort" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><strong>Baud Rate</strong></th>
                                            <td><asp:Label ID="lblCommBaud" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><strong>ComAp(s)</strong></th>
                                            <td><asp:Label ID="lblComapAddr" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><strong>Heat Meter(s)</strong></th>
                                            <td><asp:Label ID="lblHMAddr" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><strong>Steam Meter(s)</strong></th>
                                            <td><asp:Label ID="lblSteamAddr" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><strong>Gas Meter(s)</strong></th>
                                            <td><asp:Label ID="lblGasAddr" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><strong>Ethernet Module</strong></th>
                                            <td><asp:Label ID="lblEthernetEn" runat="server" Text=""></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="col-md-4">
                            <table class="table table-condensed">
                              <thead>
                                <tr>
                                  <th colspan="2"><h3>History.</h3></th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <th scope="row"><strong>Total Columns</strong></th>
                                  <td><asp:Label ID="lblHistoryTotal" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                  <th scope="row"><strong>Valid</strong></th>
                                  <td><asp:Label ID="lblHistoryValid" runat="server" Text=""></asp:Label></td>
                                </tr>
                                <tr>
                                  <th scope="row"><strong>Unknown</strong></th>
                                  <td><asp:Label ID="lblHistoryUnknown" runat="server" Text=""></asp:Label></td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                        </div>
                        <asp:BulletedList ID="blFinalErrors" runat="Server" BulletStyle="NotSet" ForeColor="Red">
                        </asp:BulletedList>
                        <hr />
                        <div class="col-md-8 col-md-offset-4">
                            <asp:LinkButton ID="SaveBtn" runat="server" CssClass="btn btn-primary" OnClick="SubmitBtn_Click" Enabled="false">
                                <i aria-hidden="true" class="fa fa-floppy-o"></i> Save
                            </asp:LinkButton>
                            <asp:LinkButton ID="CancelBtn" runat="server" CssClass="btn btn-primary" validationgroup="vgStep1">
                                <i aria-hidden="true" class="fa fa-ban"></i> Cancel
                            </asp:LinkButton>
                        </div>

                        <div class="acc-wizard-step"><%--<button class="btn" type="reset">Go Back</button>--%></div>
                    </div>
                </div>
                <!--/.panel-body -->
            </div> <!-- /#History -->
          </div> <!-- /.panel.panel-default -->
          
        </div>
      </div>
    </div>

    <script src="../Scripts/Acc-Wizard/acc-wizard.min.js"></script>
    <script>
        $(window).load(function () {
            $(".acc-wizard").accwizard({});
        })
    </script>

    <script type="text/javascript">
        function markComplete(id)
        {
            hash = "#" + id;
            $(".acc-wizard-sidebar")
                .children("li")
                .children("a[href='" + hash + "']")
                .parent("li")
                .removeClass("acc-wizard-todo")
                .addClass("acc-wizard-completed");
        }

        function openWiz(location) {
            if (location == '#Comms') {
                if (Page_ClientValidate("vgStep1"))
                {
                    markComplete('Unit');
                    window.location.href = location;
                }
            }
            else if (location == '#History')
            {
                if (Page_ClientValidate("vgStep2")) {
                    markComplete('Unit');
                    markComplete('Comms');
                    window.location.href = location;
                }
            }
            else if (location == '#Summary')
            {
                markComplete('Unit');
                markComplete('Comms');
                markComplete('History');
            }
        }

        //Function to generate an error message
        bootstrap_alert = function () { }
        bootstrap_alert.warning = function (csstype, subject, message) {
            $('#alert_placeholder').html('<div class="alert ' + csstype + '"><a class="close" data-dismiss="alert">×</a><span><strong>' + subject + ' ' + '</strong>' + message + '</span></div>')
        }
    </script>
 
    <script type="text/javascript">
        function uploadComplete(sender) {
            //document.forms[0].target = "";
            <%--$get("<%=lblMesg.ClientID%>").innerHTML = "File Uploaded Successfully";--%>
            <%--__doPostBack('<%=UpdatePanelUpload.ClientID %>', '');--%>
            //__doPostBack('UpdatePanelUpload', '');
        }
        function uploadError(sender) {
           <%-- $get("<%=lblMesg.ClientID%>").innerHTML = "File upload failed.";--%>
        }

        function postback_UpdatePanelUpload(sender) {
           <%-- $get("<%=lblMesg.ClientID%>").innerHTML = "Hello from CB: " + sender;--%>
            __doPostBack(sender, '');
        }

    </script>

    <script type="text/javascript">
        //User GUI Validation
        function isUnitSerialValid(source, arguments) {
            var IsValid;
            var msg;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsSerialValid",
                data: "{'serial': '" + arguments.Value + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg; 
                }
            });
            
            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isSiteNameValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%=ddlExistingSites.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsSiteNameValid",
                data: "{'siteName': '" + arguments.Value + "', 'existingSite': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap1SerialValid(source, arguments) {
            var IsValid;
            var msg;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap1SerialValid",
                data: "{'serial': '" + arguments.Value + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap2SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap2SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap3SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap3SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap4SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap4SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap5SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap5SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap6SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap6SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap7SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap7SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }

        function isComap8SerialValid(source, arguments) {
            var IsValid;
            var msg;
            var ddl = document.getElementById("<%= ddlComapCount.ClientID %>");
            var ddlVal = ddl.options[ddl.selectedIndex].value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddUnit.aspx/IsComap8SerialValid",
                data: "{'serial': '" + arguments.Value + "', 'comapCount': '" + ddlVal + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    IsValid = result.d.IsValid;
                    msg = result.d.Msg;
                }
            });

            arguments.IsValid = IsValid;
            source.innerHTML = msg;
        }
    </script>

</asp:Content>
