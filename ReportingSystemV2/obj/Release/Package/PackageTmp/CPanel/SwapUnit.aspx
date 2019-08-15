<%@ Page Title="" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="SwapUnit.aspx.cs" Inherits="ReportingSystemV2.CPanel.SwapUnit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <div class="row acc-wizard">
      <div class="col-md-3" style="padding-left: 2em;">
        <p style="margin-bottom: 2em;">
          Follow the steps below to replace an existing site datalogger unit with a new unit.
        </p>
        <ol class="acc-wizard-sidebar">
          <li class="acc-wizard-todo"><a href="#Existing">Site</a></li>
          <li class="acc-wizard-todo"><a href="#New">New Unit</a></li>
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
                  Select a site to replace the datalogger
                <%--</a>--%>
              </h4>
            </div>
            <div id="Existing" class="panel-collapse collapse" style="height: 36.4000015258789px;">
              <div class="panel-body">
                <div id="form-Existing">

                    <p>
                        To swap a unit you must first complete the steps in this wizard:
                    </p>
                    <ul>
                        <li>Identify the site where you wish to copy the datalogger settings from.
                        </li>
                        <li>Give details about the new unit, such as: The site name and datalogger unit serial number.
                        </li>
                    </ul>
                  <p></p>
                    <asp:UpdatePanel ID="UpdPnlExisting" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-md-4 control-label">Select Site</label>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlExistingSites" CssClass="form-control select fa-caret-down" runat="server" TabIndex="1"
                                    OnSelectedIndexChanged="ddlExistingSites_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label">Existing Unit Serial</label>
                            <div class="col-md-4">
                                <asp:TextBox ID="tbExistingSerial" runat="server" CssClass="form-control input-md" TabIndex="2" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                <div class="acc-wizard-step"><%--<button id="btnUnitNext" runat="server" class="btn btn-primary" type="submit" validationgroup="vg1" causesvalidation="true">Next Step </button>--%>
                    <asp:Button ID="unitNext" runat="server" Text="Next Step " OnClientClick="openWiz('#New'); return false;" ValidationGroup="vgStep1" CausesValidation="true"  CssClass="btn btn-primary"/>
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
            <div id="New" class="panel-collapse collapse" style="height: 36.4000015258789px;">
              <div class="panel-body">
                  <div id="form-New">
                      <p>
                          Next, you must insert the serial number and select the model of the new datalogger unit.
                      </p>
                      This will include:
                      <ul>
                          <li>Selecting the desired port for connection to the controller, RS232-Front or RS485-Rear.</li>
                          <li>Selecting the desired baud rate (57600bps recomended).</li>
                      </ul>

<%--                      <asp:UpdatePanel ID="UpdPnlCommunications" runat="server" UpdateMode="Conditional">
                          <ContentTemplate>
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
                                          </asp:DropDownList>
                                      </div>
                                  </div>
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
                              </div>
                          </ContentTemplate>
                      </asp:UpdatePanel>--%>

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
                            <%--<asp:LinkButton ID="SaveBtn" runat="server" CssClass="btn btn-primary" OnClick="SubmitBtn_Click" Enabled="false">
                                <i aria-hidden="true" class="fa fa-floppy-o"></i> Save
                            </asp:LinkButton>--%>
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

</asp:Content>
