import React from "react";
import { useIsMobile } from "../../util/use-is-mobile.hook";
import MobileClientsTable from "./mobile-clients-table.component";
import DesktopClientsTable from "./desktop-clients-table.component";
import { SingleClient } from "../../view-edit-client/view-client.component";

export default function ClientsTable(props: ClientsTableProps) {
  const isMobile = useIsMobile();

  return isMobile ? (
    <MobileClientsTable {...props} />
  ) : (
    <DesktopClientsTable {...props} />
  );
}

export type ClientsTableProps = {
  clients: SingleClient[];
};
