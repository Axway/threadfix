////////////////////////////////////////////////////////////////////////
//
//     Copyright (c) 2009-2015 Denim Group, Ltd.
//
//     The contents of this file are subject to the Mozilla Public License
//     Version 2.0 (the "License"); you may not use this file except in
//     compliance with the License. You may obtain a copy of the License at
//     http://www.mozilla.org/MPL/
//
//     Software distributed under the License is distributed on an "AS IS"
//     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
//     License for the specific language governing rights and limitations
//     under the License.
//
//     The Original Code is ThreadFix.
//
//     The Initial Developer of the Original Code is Denim Group, Ltd.
//     Portions created by Denim Group, Ltd. are Copyright (C)
//     Denim Group, Ltd. All Rights Reserved.
//
//     Contributor(s): Denim Group, Ltd.
//
////////////////////////////////////////////////////////////////////////

package com.denimgroup.threadfix.plugin.zap.dialog;

import org.apache.log4j.Logger;
import org.parosproxy.paros.extension.ViewDelegate;
import org.zaproxy.zap.extension.threadfix.ZapPropertiesManager;

import javax.swing.*;
import java.awt.*;

public class SourceDialog {

    private static final Logger logger = Logger.getLogger(SourceDialog.class);

    public static boolean show(final ViewDelegate view) {
        logger.info("Attempting to show dialog.");
        final JLabel sourceFolderLabel = new JLabel("Source Code Folder");
        final JTextField sourceFolderField = new JTextField(40);
        sourceFolderField.setText(ZapPropertiesManager.INSTANCE.getSourceFolder());
        final JButton browseButton = new JButton("Browse");
        browseButton.addActionListener(new java.awt.event.ActionListener() {
            @Override
            public void actionPerformed(java.awt.event.ActionEvent e) {
                JFileChooser chooser = new JFileChooser();
                String currentDirectory = sourceFolderField.getText();
                if ((currentDirectory == null) || (currentDirectory.trim().equals(""))) {
                    currentDirectory = System.getProperty("user.home");
                }
                chooser.setCurrentDirectory(new java.io.File(currentDirectory));
                chooser.setDialogTitle("Select A Source Code Folder");
                chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
                chooser.setAcceptAllFileFilterUsed(false);
                if (chooser.showOpenDialog(view.getMainFrame()) == JFileChooser.APPROVE_OPTION) {
                    sourceFolderField.setText(chooser.getSelectedFile().getAbsolutePath());
                }
            }
        });

        GridBagLayout experimentLayout = new GridBagLayout();
        GridBagConstraints labelConstraints = new GridBagConstraints();
        labelConstraints.gridwidth = 1;
        labelConstraints.gridx = 0;
        labelConstraints.gridy = 0;
        labelConstraints.fill = GridBagConstraints.HORIZONTAL;
        GridBagConstraints textBoxConstraints = new GridBagConstraints();
        textBoxConstraints.gridwidth = 4;
        textBoxConstraints.gridx = 1;
        textBoxConstraints.gridy = 0;
        textBoxConstraints.fill = GridBagConstraints.HORIZONTAL;
        GridBagConstraints browseButtonConstraints = new GridBagConstraints();
        browseButtonConstraints.gridwidth = 1;
        browseButtonConstraints.gridx = 5;
        browseButtonConstraints.gridy = 0;
        browseButtonConstraints.fill = GridBagConstraints.HORIZONTAL;

        JPanel myPanel = new JPanel();
        myPanel.setLayout(experimentLayout);
        myPanel.add(sourceFolderLabel, labelConstraints);
        myPanel.add(sourceFolderField, textBoxConstraints);
        myPanel.add(browseButton, browseButtonConstraints);

        String attempt = SourceDialog.class.getProtectionDomain().getCodeSource().getLocation().getFile() + "/dg-icon.png";

        logger.info("Trying " + attempt);

        ImageIcon icon = new ImageIcon(attempt);

        int result = JOptionPane.showConfirmDialog(view.getMainFrame(),
                myPanel,
                "Please enter the location of the source code",
                JOptionPane.OK_CANCEL_OPTION,
                JOptionPane.INFORMATION_MESSAGE,
                icon);
        if (result == JOptionPane.OK_OPTION) {
            ZapPropertiesManager.setSourceFolder(sourceFolderField.getText());
            logger.info("Got properties and saved.");
            return true;
        } else {
            logger.info("Cancel pressed.");
            return false;
        }
    }

}
